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

final class MonthMemoryViewModel: CommonViewModel {
    
    struct Input {
        let tasks: BehaviorRelay<[UserMemory]>
        let tableViewDidSelect: ControlEvent<IndexPath>
    }
    
    struct Output {
        let tableViewCellForRowAt: BehaviorRelay<[UserMemory]>
        let checkTasksCount: Observable<Bool>
        let tableViewIndex: ControlEvent<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let checkTasksCount = input.tasks.map { $0.count == 0 }
        
        return Output(tableViewCellForRowAt: input.tasks, checkTasksCount: checkTasksCount, tableViewIndex: input.tableViewDidSelect)
    }
    
    let repository = UserRepository()

    var tasks = BehaviorRelay<[UserMemory]>(value: [])
    
    var monthDate = ""
    
    func fetchDateFiltered() {
        tasks.accept(repository.fetchDateFiltered(dateString: monthDate).map { $0 })
    }
    
    func fetchImageArray(imageList: List<Data>) -> [Data]{
        return imageList.map { $0 }
    }
    
    func fetchTaskData() -> [UserMemory] {
        
        return tasks.value
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
