//
//  Date+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//

import Foundation

enum DateFormatterType {
    
    case simple, full, onlyTime
    
    var dateFormat: String {
        switch self {
        case .simple:
            return "yyyy. MM. dd"
        case .full:
            return "yyyy년 MM월 dd일(E) a hh:mm"
        case .onlyTime:
            return "a hh:mm"
        }
    }
}

extension Date {
    func dateToString(type: DateFormatterType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        switch type {
        case .simple:
            dateFormatter.dateFormat = DateFormatterType.simple.dateFormat
        case .full:
            dateFormatter.dateFormat = DateFormatterType.full.dateFormat
        case .onlyTime:
            dateFormatter.dateFormat = DateFormatterType.onlyTime.dateFormat
        }
        
        return dateFormatter.string(from: self)
    }
    func nearestHour() -> Date {
        let calendar = Calendar.current
        let currentMinute = calendar.component(.minute, from: self)
        if currentMinute == 0 {
            return calendar.date(byAdding: .minute, value: 0, to: self)!
        } else {
            let roundedMinute = 60 - currentMinute
            return calendar.date(byAdding: .minute, value: roundedMinute, to: self)!
        }
    }
}
