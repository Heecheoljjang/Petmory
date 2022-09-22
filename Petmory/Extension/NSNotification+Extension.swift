//
//  NSNotification+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/17.
//

import Foundation

extension NSNotification.Name {
    static let doneButton = NSNotification.Name("reloadTableViewDoneButton")
    static let deleteButton = NSNotification.Name("reloadTableViewDeleteButton")
    static let editWriting = NSNotification.Name("settingTask")
    static let reloadCollectionView = NSNotification.Name("reloadImageCollectionView")
}
