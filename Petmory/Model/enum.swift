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
    static let version = "버전 정보"
}

enum SettingListImage {
    static let backupImage = "cloud"
    static let message = "pencil"
    static let review = "star"
    static let openLicense = "doc"
    static let version = "info.circle"
}

enum ErrorType: Error {
    case encodingError, decodingError, zipError, documentPathError, savingFileError, pathAddingError, unzipError, fetchJsonDataError
}

enum BackupFileName {
    static let memory = "memory"
    static let calendar = "calendar"
    static let pet = "pet"
}

enum NotificationType {
    case calendar, pet
}

enum PlaceholderText {
    static let title = "제목"
    static let memo = "메모"
}

enum ImageName {
    //MARK: 탭바 아이콘
    static let diaryIcon = "DiaryTabBarIcon"
    static let calendarIcon = "CalendarTabBarIcon"
    static let petIcon = "PetTabBarIcon"
    
    //MARK: 시스템 이미지
    static let multiSign = "rectangle.fill.on.rectangle.angled.fill"
    static let chevronDown = "chevron.down"
    static let chevronLeft = "chevron.left"
    static let magnifyingglass = "magnifyingglass"
    static let pencil = "pencil"
    static let menu = "line.horizontal.3"
    static let gear = "gearshape"
    static let xmark = "xmark"
    static let delete = "trash"
    static let ellipsis = "ellipsis"
    static let camera = "camera"
    static let plus = "plus"
    static let file = "doc.text"
    //백업
    static let backupImage = "cloud"
    static let message = "pencil"
    static let review = "star"
    static let openLicense = "doc"
    static let version = "info.circle"

}
