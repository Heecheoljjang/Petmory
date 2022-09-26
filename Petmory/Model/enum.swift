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

enum SettingList {
    static let backup = "백업"
    static let restore = "복구"
    static let message = "문의하기"
    static let review = "리뷰 남기기"
    static let shareApp = "앱 공유하기"
}

enum ErrorType: Error {
    case encodingError, decodingError, zipError, documentPathError, savingFileError, pathAddingError, unzipError, fetchJsonDataError
}

enum BackupFileName {
    static let memory = "memory"
    static let calendar = "calendar"
    static let pet = "pet"
}
