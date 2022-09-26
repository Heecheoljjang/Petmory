//
//  UserCalendar.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import Foundation
import RealmSwift

final class UserCalendar: Object, Codable {
    
    @Persisted var title: String
    @Persisted var date = Date()
    @Persisted var dateString: String
    @Persisted var color: String
    @Persisted var comment: String
    @Persisted var registerDate = Date()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, date: Date, dateString: String, color: String, comment: String, registerDate: Date) {
        self.init()
        self.title = title
        self.date = date
        self.dateString = dateString
        self.color = color
        self.comment = comment
        self.registerDate = registerDate
    }
    
    enum CodingKeys: String, CodingKey {
        case title, date, dateString, color, comment, registerDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(dateString, forKey: .dateString)
        try container.encode(color, forKey: .color)
        try container.encode(comment, forKey: .comment)
        try container.encode(registerDate, forKey: .registerDate)
    }
}
