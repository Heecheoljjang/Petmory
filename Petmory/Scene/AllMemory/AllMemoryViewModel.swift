//
//  AllMemoryViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/28.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

final class AllMemoryViewModel {
    
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
