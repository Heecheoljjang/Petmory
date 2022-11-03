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
    
    var tasksCount = BehaviorRelay<Bool>(value: true) //태스크의 카운트가 0인지 확인하는 프로퍼티
    
    var petListCount = BehaviorRelay<Bool>(value: true)
    
    var imageCount = BehaviorRelay<Int>(value: 0) //이미지 카운트 => tasks 불러올때마다 같이 업데이트되게하면될듯
    //그리고 메서드로 bool값 이용해야할ㄷ스
    
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
    //MARK: task의 카운트 바뀔때마다 값 바꿔주고, 이 tasksCount가 바뀔때마다 isHidden bind
//    func checkTasksCount() {
//        return tasks.value?.count == 0 ? true : false
//    }
    
    //MARK: 얘도 따로 생각해보기
//    func checkPetListCount(item: Int) -> Bool {
//        guard let count = petList.value?[item].petName.count else { return false }
//
//        return count > 1 ? true : false
//    }
    
//    func numberOfRows(section: Int) -> Int {
//        return tasks.value?.filter("\(RealmModelColumn.memoryDateString) CONTAINS[c] '\(dateList.value[section])'").count ?? 0
//    }
//
//    func numberOfItems() -> Int {
//        return petList.value?.count ?? 0
//    }
//
//    func tableViewCellTask(section: Int, row: Int) -> UserMemory? {
//        return tasks.value?.filter("\(RealmModelColumn.memoryDateString) CONTAINS[c] '\(dateList.value[section])'").sorted(byKeyPath: RealmModelColumn.memoryDate, ascending: false)[row]
//    }
    
//    func cellText(task: UserMemory, type: CellTextType) -> String {
//        switch type {
//        case .title:
//            return task.memoryTitle
//        case .content:
//            return task.memoryContent
//        case .date:
//            return task.memoryDate.dateToString(type: .monthDay)
//        }
//    }
    

}
