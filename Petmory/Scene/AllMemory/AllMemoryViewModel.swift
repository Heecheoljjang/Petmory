//
//  AllMemoryViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/28.
//

import Foundation
import RealmSwift

final class AllMemoryViewModel {
    
    let repository = UserRepository()
    
    var tasks: Observable<Results<UserMemory>?> = Observable(nil)
    
    var petList: Observable<Results<UserPet>?> = Observable(nil)
    
    var filterPetName: Observable<String> = Observable("")
    
    var dateList: Observable<[String]> = Observable([])
    
    func fetchAllMemory() {
        tasks.value = repository.fetchAllMemory()
    }
    
    func fetchPetList() {
        petList.value = repository.fetchPet()
    }
    
    func fetchPetName(item: Int) -> String {
        guard let pet = petList.value?[item] else { return "" }
        
        return pet.petName
    }
    
    func fetchFiltered(name: String) {
        tasks.value = repository.fetchFiltered(name: name)
    }
    
    func checkTasksCount() -> Bool {
        return tasks.value?.count == 0 ? true : false
    }
    
    func checkPetListCount(item: Int) -> Bool {
        guard let count = petList.value?[item].petName.count else { return false }
        
        return count > 1 ? true : false
    }
    
    func numberOfRows(section: Int) -> Int {
        return tasks.value?.filter("\(RealmModelColumn.memoryDateString) CONTAINS[c] '\(dateList.value[section])'").count ?? 0
    }
    
    func numberOfItems() -> Int {
        return petList.value?.count ?? 0
    }
    
    func tableViewCellTask(section: Int, row: Int) -> UserMemory? {
        return tasks.value?.filter("\(RealmModelColumn.memoryDateString) CONTAINS[c] '\(dateList.value[section])'").sorted(byKeyPath: RealmModelColumn.memoryDate, ascending: false)[row]
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
    
    func checkImageDataCount(task: UserMemory, compareType: CompareType) -> Bool {
        switch compareType {
        case .equal:
            return task.imageData.count == 0 ? true : false
        case .greater:
            return task.imageData.count > 1 ? true : false
        }
    }
    
    func setFilterPetName(name: String) {
        filterPetName.value = name
    }
}
