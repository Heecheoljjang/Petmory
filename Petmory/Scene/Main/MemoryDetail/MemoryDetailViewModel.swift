//
//  MemoryDetailViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/31.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

final class MemoryDetailViewModel {
    
    let repository = UserRepository()
    
//    var memoryTask: Observable<UserMemory?> = Observable(nil)
    var memoryTask = BehaviorRelay<UserMemory?>(value: nil)
    
    var objectId = ""
    
//    var imageList: Observable<List<Data>?> = Observable(nil)
    var imageList = BehaviorRelay<[Data]>(value: [])
    
    var isEditStatus = false
    
    func checkStatus() -> Bool {
        return isEditStatus == false ? true : false
    }
    
    func fetchWithObjectId() {
        memoryTask.accept(repository.fetchWithObjectId(objectId: objectId).first)
    }
    
    func checkImageListCount() -> Bool {
        return imageList.value.count == 0 ? true : false
    }
    
    func fetchImageListCount() -> Int {
        return imageList.value.count
    }
    
    func deleteMemory(item: UserMemory) {
        repository.deleteMemory(item: item)
    }
    
    func setStatusEdit() -> CurrentStatus {
        return CurrentStatus.edit
    }
    
    func appendImageData(list: List<Data>) {
        memoryTask.value?.imageData.forEach {
            list.append($0)
        }
    }
}
