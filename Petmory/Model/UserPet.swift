//
//  UserPet.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import Foundation
import RealmSwift

final class UserPet: Object {
    
    @Persisted var profileImage: Data?
    @Persisted var petName: String
    @Persisted var birthday: Date?
    @Persisted var gender: String
    @Persisted var comment: String
    @Persisted var registerDate = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(profileImage: Data?, petName: String, birthday: Date?, gender: String, comment: String, registerDate: Date) {
        self.init()
        self.profileImage = profileImage
        self.petName = petName
        self.birthday = birthday
        self.gender = gender
        self.comment = comment
        self.registerDate = registerDate
    }
    
}
