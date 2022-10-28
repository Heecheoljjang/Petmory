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
    static let askToday = "오늘 하루를 어떻게 보내셨나요?"
    static let dateAndTime = "날짜 및 시간"
    static let writeName = "이름을 입력해주세요."
    static let selectBirthday = "생일을 선택해주세요."
    static let search = "제목, 내용 검색"
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

enum RealmModelColumn {
    static let memoryDateString = "memoryDateString"
    static let memoryDate = "memoryDate"
}

enum AlertText {
    static let select = "선택"
    static let cancel = "취소"
    static let edit = "수정"
    static let delete = "삭제"
    static let ok = "확인"
}

enum LabelText {
    static let noMemory = "작성한 기록이 없습니다!"
    static let with = "with"
    static let zeroMemory = "사랑하는 반려동물과의\n\n소중한 하루를 기록해보세요 :)"
    static let noCalendar = "일정 없음"
    static let memo = "메모"
    static let nameWithColon = "이름 :"
    static let birthDayWithColon = "생일 :"
    static let gender = "성별"
    static let backupFile = "백업 파일"
}

enum NavigationTitleLabel {
    static let allMemory = "모아보기"
    static let contents = "내용"
    static let registerPet = "반려동물 등록"
    static let myPet = "나의 반려동물"
    static let backupRestore = "백업 및 복구"
    static let setting = "설정"
}

enum AlertTitle {
    static let registerPet = "반려동물을 등록해주세요!"
    static let checkDelete = "삭제하시겠습니까?"
    static let checkCancel = "취소하시겠습니까?"
    static let doneWriting = "작성 완료!"
    static let doneEditing = "수정 완료!"
    static let maximumPhoto = "최대 두 장까지 추가할 수 있습니다."
    static let noPetName = "이름을 입력해주세요."
    static let noPetProfilePhoto = "사진을 등록해주세요."
    static let alreadyRegisteredName = "이미 등록된 이름입니다."
    static let noPetGender = "성별을 선택해주세요."
    static let noPetBirthday = "생일을 입력해주세요."
    static let backup = "백업"
    static let failZip = "압축 실패"
    static let failUnzip = "압축 해제 실패"
    static let restore = "복구"
    static let error = "오류"
    static let noFile = "선택하신 파일을 찾을 수 없습니다."
    static let export = "내보내기"
    static let checkEmail = "등록된 메일 계정을 확인해주세요."
}

enum AlertMessage {
    static let willNotSave = "작성중인 내용은 저장되지 않습니다."
    static let noTitle = "제목을 입력해주세요."
    static let selectPet = "함께한 반려동물을 선택해주세요."
    static let anotherName = "다른 이름을 사용해주세요."
    static let makeBackup = "백업 파일을 만드시겠습니까?"
    static let checkFile = "다시 확인해주세요."
    static let checkRestore = "복구가 진행되면 기존의 데이터는 사라집니다. 복구를 진행하시겠습니까?"
    static let notPetmoryFile = "Petmory의 백업 파일이 아닙니다."
}

enum ButtonTitle {
    static let cancel = "취소"
    static let done = "완료"
    static let delete = "삭제"
    static let today = "오늘"
    static let register = "등록"
    static let edit = "수정"
    static let boy = "남아"
    static let girl = "여아"
    static let registerPet = "반려동물 등록하기"
    static let makeBackupFile = "백업 파일 생성"
    static let restore = "복구"
}

enum NotificationContentText {
    static let todayCalendar = "오늘의 일정"
    static let happyDay = "소중한 하루를 선물해주세요 :)"
}

enum BackupLabel {
    static let backupMessage = "앱 삭제 시 백업 파일도 함께 삭제되기 때문에 파일 앱 등에 따로 저장해두는 것을 권장합니다."
}

enum CompareType {
    case equal, greater
}

enum CellTextType {
    case title, content, date
}
