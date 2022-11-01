//
//  MyPetViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/28.
//

import Foundation
import RealmSwift

final class MyPetViewModel {
    
    var tasks: MVVMObservable<Results<UserPet>?> = MVVMObservable(nil)
    
    let repository = UserRepository()
    
    func fetchPet() {
        tasks.value = repository.fetchPet()
    }
    
    func fetchTaskCount() -> Int {
        return tasks.value?.count ?? 0
    }
}
