//
//  UICollectionViewCell+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }

}

