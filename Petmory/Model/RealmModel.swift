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
    @Persisted var memoryDate = Date()
    @Persisted var petList: List<String>
    @Persisted var memoryContent: String
    @Persisted var imageData: List<Data>
    
    @Persisted(primaryKey: true) var objectId: String
    
    convenience init(memoryTitle: String, memoryDate: Date, petList: List<String>, memoryContent: String, imageData: List<Data>, objectId: String) {
        self.init()
        self.memoryTitle = memoryTitle
        self.memoryDate = memoryDate
        self.memoryContent = memoryContent
        self.petList = petList
        self.imageData = imageData
        self.objectId = objectId
    }
}

final class UserPet: Object {
    
    @Persisted var petName: String
    @Persisted var birthday = Date()
    @Persisted var gender: Bool
    @Persisted var comment: String
    @Persisted var registerDate = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(petName: String, birthday: Date, gender: Bool, comment: String, registerDate: Date) {
        self.init()
        self.petName = petName
        self.birthday = birthday
        self.gender = gender
        self.comment = comment
        self.registerDate = registerDate
    }
    
}
