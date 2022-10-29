//
//  MonthMemoryViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/29.
//

import Foundation
import RealmSwift

final class MonthMemoryViewModel {
    
    let repository = UserRepository()
    
    var tasks: Observable<Results<UserMemory>?> = Observable(nil)
    
    var monthDate: Observable<String> = Observable("")
    
    func fetchDateFiltered() {
        tasks.value = repository.fetchDateFiltered(dateString: monthDate.value)
    }
    
    func checkTasksCount() -> Bool {
        return tasks.value?.count == 0 ? true : false
    }
    
    func fetchTasksCount() -> Int {
        return tasks.value?.count ?? 0
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
}
