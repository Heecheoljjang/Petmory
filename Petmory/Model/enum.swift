//
//  Enum.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/16.
//

import Foundation

//MARK: - 새 작성 / 수정 구분
enum CurrentStatus {
    static let edit = false
    static let new = true
}

enum DateComponent: String {
    case year, month, day, hour, minute, second
}
