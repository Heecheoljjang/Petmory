//
//  RealmModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/08.
//

import Foundation
import RealmSwift

final class UserMemory: Object, Codable {
    
    @Persisted var memoryTitle: String
    @Persisted var memoryDateString: String
    @Persisted var petList: List<String>
    @Persisted var memoryContent: String
    @Persisted var imageData: List<Data>
    @Persisted var memoryDate = Date()
    
    @Persisted(primaryKey: true) var objectId: String
    
    convenience init(memoryTitle: String, memoryDateString: String, petList: List<String>, memoryContent: String, imageData: List<Data>, memoryDate: Date, objectId: String) {
        self.init()
        self.memoryTitle = memoryTitle
        self.memoryDateString = memoryDateString
        self.memoryDate = memoryDate
        self.memoryContent = memoryContent
        self.petList = petList
        self.imageData = imageData
        self.objectId = objectId
    }
    
    enum CodingKeys: String, CodingKey {
        case memoryTitle, memoryDateString, petList, memoryContent, imageData, memoryDate, objectId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(memoryTitle, forKey: .memoryTitle)
        try container.encode(memoryDateString, forKey: .memoryDateString)
        try container.encode(petList, forKey: .petList)
        try container.encode(memoryContent, forKey: .memoryContent)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(memoryDate, forKey: .memoryDate)
        try container.encode(objectId, forKey: .objectId)
    }
}

