//
//  MemoryDetailViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/31.
//

import Foundation
import RealmSwift

final class MemoryDetailViewModel {
    
    let repository = UserRepository()
    
    var memoryTask: Observable<UserMemory?> = Observable(nil)
    
    var objectId = ""
    
    var imageList: Observable<List<Data>?> = Observable(nil)
    
    var isEditStatus = false
    
    func checkStatus() -> Bool {
        return isEditStatus == false ? true : false
    }
    
    func fetchWithObjectId() {
        memoryTask.value = repository.fetchWithObjectId(objectId: objectId).first
    }
    
    func checkImageListCount() -> Bool {
        return imageList.value?.count == 0 ? true : false
    }
    
    func fetchImageListCount() -> Int {
        return imageList.value?.count ?? 0
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
