//
//  MonthMemoryViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/29.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

//MARK: 옵저버블처럼 value에 접근하는 방식이 아닌 매번 메서드에서 repository의 메서드를 실행하는 느낌인지 궁금
final class MonthMemoryViewModel {
    
    let repository = UserRepository()
    
//    var tasks: Observable<Results<UserMemory>?> = Observable(nil)
//
//    var monthDate: Observable<String> = Observable("")
    var tasks = BehaviorSubject<[UserMemory]>(value: [])
    
    var monthDate = ""
    
    func fetchDateFiltered() {
//        tasks.value = repository.fetchDateFiltered(dateString: monthDate.value)
        
//        날짜 필터링한 결과를 tasks에 onNext
        tasks.onNext(repository.fetchDateFiltered(dateString: monthDate).map { $0 })
        print(try! tasks.value())
    }
    
    func fetchTaskData() -> [UserMemory] {
        
        guard let taskData = try? tasks.value() else { return [] }
        
        return taskData
    }
    
//    func checkTasksCount() -> Bool {
//        return tasks.value?.count == 0 ? true : false
//    }
//

    
//    func fetchTasksCount() -> Int {
//        return tasks.value?.count ?? 0
//    }
    
//    func fetchTasksCount(tasks: )
    
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
