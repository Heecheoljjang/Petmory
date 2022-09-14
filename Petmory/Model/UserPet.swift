//
//  UserPet.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import Foundation
import RealmSwift

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
