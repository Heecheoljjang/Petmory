//
//  Setting.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/23.
//

import Foundation

final class Setting: Hashable {

    var id = UUID()
    var title: String
    var image: String
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Setting, rhs: Setting) -> Bool {
        lhs.id == rhs.id
    }
}

extension Setting {
    
    static let allSettings: [Setting] = [
        Setting(title: SettingList.backupRestore, image: SettingListImage.backupImage),
        Setting(title: SettingList.message, image: SettingListImage.message),
        Setting(title: SettingList.review, image: SettingListImage.review)
    ]
    
}
