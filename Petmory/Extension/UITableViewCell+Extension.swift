//
//  UITableViewCell+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
