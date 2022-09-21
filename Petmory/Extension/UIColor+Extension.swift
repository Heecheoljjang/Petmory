//
//  UIColor+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit

enum CustomColor: String {
    case customRed, customPink, customYellow, customMint, customGreen, customBlue, customPurple, customDefault
}

extension UIColor {
    static let diaryColor = UIColor(red: 0x40/0xFF, green: 0x53/0xFF, blue: 0x36/0xFF, alpha: 1)
    static let stringColor = UIColor(red: 0xEC/0xFF, green: 0xD8/0xFF, blue: 0xCF/0xFF, alpha: 1)
    static let placeholderColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
    static let lightDiaryColor = UIColor(red: 0xE8/0xFF, green: 0xEA/0xFF, blue: 0xE6/0xFF, alpha: 1)
    static let lightStringColor = UIColor(red: 0xF2/0xFF, green: 0xED/0xFF, blue: 0xD7/0xFF, alpha: 1)
    static let weekdayColor = UIColor(red: 0xCD/0xFF, green: 0xD0/0xFF, blue: 0xCB/0xFF, alpha: 1)
    //CDD0CB
    //MARK: Tag Color
    static let customRed = UIColor(red: 0xDC/0xFF, green: 0x14/0xFF, blue: 0x3D/0xFF, alpha: 1)
    static let customPink = UIColor(red: 0xFF/0xFF, green: 0xB7/0xFF, blue: 0xCB/0xFF, alpha: 1)
    static let customPurple = UIColor(red: 0xAE/0xFF, green: 0x63/0xFF, blue: 0x9B/0xFF, alpha: 1)
    static let customGreen = UIColor(red: 0x40/0xFF, green: 0x53/0xFF, blue: 0x36/0xFF, alpha: 1)
    static let customMint = UIColor(red: 0x76/0xFF, green: 0xEE/0xFF, blue: 0xC6/0xFF, alpha: 1)
    static let customYellow = UIColor(red: 0xEA/0xFF, green: 0xEE/0xFF, blue: 0x80/0xFF, alpha: 1)
    static let customBlue = UIColor(red: 0x5C/0xFF, green: 0x9A/0xFF, blue: 0xD1/0xFF, alpha: 1)
    
    static func setCustomColor(_ color: String) -> UIColor {
        switch color {
        case CustomColor.customRed.rawValue:
            return UIColor.customRed
        case CustomColor.customPink.rawValue:
            return UIColor.customPink
        case CustomColor.customYellow.rawValue:
            return UIColor.customYellow
        case CustomColor.customMint.rawValue:
            return UIColor.customMint
        case CustomColor.customGreen.rawValue:
            return UIColor.customGreen
        case CustomColor.customBlue.rawValue:
            return UIColor.customBlue
        case CustomColor.customPurple.rawValue:
            return UIColor.customPurple
        default:
            return UIColor.diaryColor
        }
    }
}
