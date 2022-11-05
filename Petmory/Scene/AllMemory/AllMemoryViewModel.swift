//
//  AllMemoryViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/28.
//

import Foundation
import RxCocoa
import RxSwift

final class AllMemoryViewModel: CommonViewModel {
    
    struct Input {
        let petCount: BehaviorRelay<[UserPet]> //checkPetCount를 위해서는 petList를 받아서 map을 이용해 타입 변환. 근데 인풋으로 사용되는 것 같긴한데 뷰모델에 있는 값이라 이렇게 해주는게 맞나싶음. 근데 흐름을 보기 위해선 이렇게 하는게 자연스러울 것 같긴함
    }
    
    struct Output {
        let tasks: Driver<[UserMemory]>
        let tasksCount: Driver<Bool>
        let petList: Driver<[UserPet]>
        let checkPetCount: Driver<Bool>
        let dateList: Driver<[String]>
        let filterPetName: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let tasks = tasks.asDriver(onErrorJustReturn: [])
        let tasksCount = tasksCount.asDriver(onErrorJustReturn: false)
        let petList = petList.asDriver(onErrorJustReturn: [])
        let checkPetCount = input.petCount.map{ $0.count > 1 }.asDriver(onErrorJustReturn: false)
        let dateList = dateList.asDriver(onErrorJustReturn: [])
        let filterPetName = filterPetName.asDriver(onErrorJustReturn: "").asDriver(onErrorJustReturn: "")
        
        return Output(tasks: tasks, tasksCount: tasksCount, petList: petList, checkPetCount: checkPetCount, dateList: dateList, filterPetName: filterPetName)
    }
    
    let repository = UserRepository()
    
    var tasks = BehaviorRelay<[UserMemory]>(value: [])
    
    var petList = BehaviorRelay<[UserPet]>(value: [])
    
    var filterPetName = BehaviorRelay<String>(value: "")
    
    var dateList = BehaviorRelay<[String]>(value: [])
    
    var tasksCount = BehaviorRelay<Bool>(value: true)
    
    var petListCount = BehaviorRelay<Bool>(value: true)
    
    var imageCount = BehaviorRelay<Int>(value: 0)
    
    var sectionCount = BehaviorRelay<Int>(value: 0)
    
    func fetchAllMemory() {
        tasks.accept(repository.fetchAllMemory().map { $0 })
    }
    
    func fetchTasksCount(tasks: [UserMemory]) {
        tasksCount.accept(tasks.count == 0 ? true : false)
    }

    func fetchPetList() {
        petList.accept(repository.fetchPet().map{ $0 })
    }

    func fetchFiltered(name: String) {
        tasks.accept(repository.fetchFiltered(name: name).map{$0})
    }
    
    func fetchDateList(tasks: [UserMemory]) {
        dateList.accept(Set(tasks.map{ $0.memoryDate.dateToString(type: .yearMonth) }).sorted(by: >))
    }
    
    func checkImageDataCount(task: UserMemory, compareType: CompareType) -> Bool {
        switch compareType {
        case .equal:
            return task.imageData.count == 0 ? true : false
        case .greater:
            return task.imageData.count > 1 ? true : false
        }
    }
    
    func setFilterPetName(name: String) {
        filterPetName.accept(name)
    }

    //MARK: filterPetName으로 바인딩해보기
    func fetchPetName(item: Int) -> String {
        return petList.value[item].petName
    }
    
    func checkFilterPetName(name: String) -> Bool {
        return name.isEmpty ? true : false
    }

    func numberOfRows(section: Int) -> Int {
        return tasks.value.filter { $0.memoryDateString.contains("\(dateList.value[section])") }.count
    }

    func tableViewCellTask(section: Int, row: Int) -> UserMemory? {
        return tasks.value.filter { $0.memoryDateString.contains("\(dateList.value[section])") }.sorted { $0.memoryDate > $1.memoryDate }[row]
    }
    
    func cellText(task: UserMemory, type: CellTextType) -> String {
        switch type {
        case .title:
            return task.memoryTitle
        case .content:
            return task.memoryContent
        case .date:
            return task.memoryDate.dateToString(type: .monthDay)
        }
    }
}
