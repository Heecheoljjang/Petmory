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

final class MainViewModel {
    
    let repository = UserRepository()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
//    var tasks: Observable<Results<UserMemory>?> = Observable(nil)
//
//    var petList: Observable<Results<UserPet>?> = Observable(nil)
    
    var tasks = BehaviorRelay<[UserMemory]?>(value: [])
    
    var petList = BehaviorRelay<[UserPet]?>(value: [])
    
    let monthList = [". 01", ". 02", ". 03", ". 04", ". 05", ". 06", ". 07", ". 08", ". 09", ". 10", ". 11", ". 12"]
    
//    var tempList: Observable<[String]> = Observable([])
    var tempList = BehaviorRelay<[String]>(value: []) //MARK: 2022.01
//
//    var selectedDate: Observable<String> = Observable("")
    var selectedDate = BehaviorRelay<String>(value: "")
//
//    var currentYear: Observable<String> = Observable("")
    var currentYear = BehaviorRelay<String>(value: "") //MARK: 2022년
//
//    var countList: Observable<[Int]> = Observable([])
    var countList = BehaviorRelay<[Int]>(value: []) //MARK: 각 월의 작성된 기록 수
    
    let yearList = BehaviorRelay<[Int]>(value: [Int](1990...2050))

//    let yearList = [Int](1990...2050)
    
//    var isFirst: Observable<Bool> = Observable(true)
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
//        currentYear.value = Date().dateToString(type: .onlyYear)
        currentYear.accept(Date().dateToString(type: .onlyYear))
    }
    
    func fetchAllMemory() {
//        tasks.value = repository.fetchAllMemory()
        tasks.accept(repository.fetchAllMemory().map { $0 })
    }
    
    func fetchPet() {
//        petList.value = repository.fetchPet()
        petList.accept(repository.fetchPet().map { $0 })
    }
    
    func checkPetCount() -> Bool {
        return petList.value?.count == 0 ? true : false
    }
    
    func setCountList() {
        
//        countList.value = []
        countList.accept([])
        
        var tempArr: [Int] = []
        
        guard let memory = tasks.value else { return }
        
        tempList.value.forEach { date in
//            countList.value.append(memory.filter("\(RealmModelColumn.memoryDateString) CONTAINS[c] '\(date)'").count)
            tempArr.append(memory.filter { $0.memoryDateString.contains(date) }.count)
        }
        countList.accept(tempArr)
    }
    
    func setTempList() {
        
//        tempList.value = monthList
//        for i in 0..<monthList.count {
//            tempList.value[i] = currentYear.value + monthList[i]
//        }
        var tempArr: [String] = []
        
        tempArr.append(contentsOf: monthList)
        
        for i in 0..<monthList.count {
            tempArr[i] = currentYear.value + monthList[i]
        }
        tempList.accept(tempArr)
    }
    
    func setSelectedDate(date: String) {
//        selectedDate.value = date
        selectedDate.accept(date)
    }
    
    func firstScrollIndex() -> IndexPath {
        return IndexPath(item: Int(Date().dateToString(type: .onlyMonth))! - 1, section: 0)
    }
    
    func selectedDate(count: Int) -> Int {
        return Int(Date().dateToString(type: .onlyYear))! - count
    }
    
    func setIsNotFirst() {
        isFirst.accept(!isFirst.value)
    }
}
