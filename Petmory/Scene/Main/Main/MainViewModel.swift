//
//  MainViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/30.
//

import Foundation
import RealmSwift
import UserNotifications
import RxSwift
import RxCocoa

final class MainViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tapWritingButton: ControlEvent<Void>
        let tapTitleViewButton: ControlEvent<Void>
        let yearList: BehaviorRelay<[Int]>
        let pickerViewSelected: ControlEvent<(row: Int, component: Int)>
        let selectCollectionViewCell: ControlEvent<IndexPath>
    }
    
    struct Output {
        let currentYear: Driver<String>
//        let tempList: Driver<[String]>
        let tempList: Void
//        let tasks: Driver<[UserMemory]?>
        let tasks: Void
        let countList: Driver<[Int]>
        let tapWritingButton: ControlEvent<Void>
        let tapTitleViewButton: ControlEvent<Void>
        let pickerViewTitle: Observable<[String]>
//        let pickerViewSelected: ControlEvent<(row: Int, component: Int)>
        let pickerViewSelected: Void
        let tempAndCount: Driver<[(String, Int)]>
        let selectCollectionViewCell: ControlEvent<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let currentYear = currentYear.asDriver(onErrorJustReturn: "error")
        let tempList: Void = tempList.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] _ in
            self?.fetchAllMemory()
        })
        .disposed(by: disposeBag)
        let tasks: Void = tasks.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] _ in
            self?.setCountList()
        })
        .disposed(by: disposeBag)
        let countList = countList.asDriver(onErrorJustReturn: [])
        let pickerViewTitle = input.yearList.map { $0.map{ "\($0)년" } }
        let pickerViewSelected: Void = input.pickerViewSelected.bind(onNext: { [unowned self] row, component in
            
            self.selectedDate.accept("\(self.yearList.value[row])")
        })
        .disposed(by: disposeBag)
        let tempAndCount = tempAndCount.asDriver(onErrorJustReturn: [])
        
        return Output(currentYear: currentYear, tempList: tempList, tasks: tasks, countList: countList, tapWritingButton: input.tapWritingButton, tapTitleViewButton: input.tapTitleViewButton, pickerViewTitle: pickerViewTitle, pickerViewSelected: pickerViewSelected, tempAndCount: tempAndCount, selectCollectionViewCell: input.selectCollectionViewCell)
    }
    
    let monthList = [Int](1...12).map { ". " + String(format: "%02d", $0) }
    
    let repository = UserRepository()
    
    let notificationCenter = UNUserNotificationCenter.current()

    var tasks = BehaviorRelay<[UserMemory]?>(value: [])
    
    var petList = BehaviorRelay<[UserPet]?>(value: [])

    var tempList = BehaviorRelay<[String]>(value: []) //MARK: 2022.01

    var selectedDate = BehaviorRelay<String>(value: "")

    var currentYear = BehaviorRelay<String>(value: "") //MARK: 2022년

    var countList = BehaviorRelay<[Int]>(value: []) //MARK: 각 월의 작성된 기록 수
    
    let yearList = BehaviorRelay<[Int]>(value: [Int](1990...2050))
    
    var tempAndCount = BehaviorRelay<[(String, Int)]>(value: [])

    var isFirst = BehaviorRelay<Bool>(value: true)
    
    func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            if success == true {
                print("성공")
            } else {
                print("실패")
            }
        }
    }
    
    func setCurrentYear() {
        currentYear.accept(Date().dateToString(type: .onlyYear))
    }
    
    func fetchAllMemory() {
        tasks.accept(repository.fetchAllMemory().map { $0 })
    }
    
    func fetchPet() {
        petList.accept(repository.fetchPet().map { $0 })
    }
    
    func checkPetCount() -> Bool {
        return petList.value?.count == 0 ? true : false
    }
    
    func setCountList() {
        
        countList.accept([])
        
        var tempArr: [Int] = []
        
        guard let memory = tasks.value else { return }
        
        tempList.value.forEach { date in

            tempArr.append(memory.filter { $0.memoryDateString.contains(date) }.count)
        }
        countList.accept(tempArr)
        setTempAndCount()
    }
    
    func setTempList() {
        var tempArr: [String] = []
        
        tempArr.append(contentsOf: monthList)
        
        for i in 0..<monthList.count {
            tempArr[i] = currentYear.value + monthList[i]
        }
        tempList.accept(tempArr)
    }
    
    func setSelectedDate(date: String) {
        selectedDate.accept(date)
    }
    
    func firstScrollIndex() -> IndexPath {
        return IndexPath(item: Int(Date().dateToString(type: .onlyMonth))! - 1, section: 0)
    }
    
    func selectedDate(count: Int) -> Int {
        return Int(Date().dateToString(type: .onlyYear))! - count
    }
    
    func checkIsFirst() -> Bool {
        return isFirst.value
    }
    
    func setIsNotFirst() {
        isFirst.accept(!isFirst.value)
    }

    func setTempAndCount() {
        var temp: [(String, Int)] = []
        
        for i in 0..<tempList.value.count {
            temp.append((tempList.value[i], countList.value[i]))
        }
        tempAndCount.accept(temp)
    }
}
