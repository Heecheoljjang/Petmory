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
    static let backupRestore = "백업 및 복구"
    static let message = "문의하기"
    static let review = "리뷰 남기기"
    static let openLicense = "오픈소스 라이선스"
}

enum SettingListImage {
    static let backupImage = "cloud"
    static let message = "pencil"
    static let review = "star"
    static let openLicense = "doc"
}

enum ErrorType: Error {
    case encodingError, decodingError, zipError, documentPathError, savingFileError, pathAddingError, unzipError, fetchJsonDataError
}

enum BackupFileName {
    static let memory = "memory"
    static let calendar = "calendar"
    static let pet = "pet"
}
