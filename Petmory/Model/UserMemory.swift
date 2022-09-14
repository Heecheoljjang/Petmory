//
//  RealmModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/08.
//

import Foundation
import RealmSwift

final class UserMemory: Object {
    
    @Persisted var memoryTitle: String
    @Persisted var memoryDate: String
    @Persisted var petList: List<String>
    @Persisted var memoryContent: String
    @Persisted var imageData: List<Data>
    
    @Persisted(primaryKey: true) var objectId: String
    
    convenience init(memoryTitle: String, memoryDate: String, petList: List<String>, memoryContent: String, imageData: List<Data>, objectId: String) {
        self.init()
        self.memoryTitle = memoryTitle
        self.memoryDate = memoryDate
        self.memoryContent = memoryContent
        self.petList = petList
        self.imageData = imageData
        self.objectId = objectId
    }
}

