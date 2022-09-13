//
//  Date+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return dateFormatter.string(from: self)
    }
}
