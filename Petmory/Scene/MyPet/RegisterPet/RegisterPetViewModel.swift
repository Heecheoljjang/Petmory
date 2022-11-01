//
//  RegisterPetViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/24.
//

import Foundation
import RealmSwift
import UserNotifications

final class RegisterPetViewModel {
    
    let repository = UserRepository()
    
    let notificationCenter = UNUserNotificationCenter.current()

    var gender: MVVMObservable<String> = MVVMObservable("")
    
    var profileImage: MVVMObservable<Data?> = MVVMObservable(nil)
    
    var birthdayDate: Date = Date()
    
    var currentStatus: CurrentStatus = CurrentStatus.new
    
    var task: UserPet? = nil
    
    var petList: [String] = []
    
    //MARK: 매핑해서 넣기
    var memories: [UserMemory] = []
    
    var currentName: String = ""
    
    //MARK: - 펫리스트 가져오기
    func fetchPetList() -> [String] {
        repository.fetchPet().map { $0.petName }
    }
    
    //MARK: - 펫 삭제
    func deletePet(item: UserPet) {
        repository.deletePet(item: item)
    }
    
    //MARK: - 기록 가져오기
    func fetchMemories() -> [UserMemory] {
        repository.fetchAllMemory().map { $0 }
    }
    
    //MARK: - 노티보내기
    func sendNotification(name: String, date: Date, identifier: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = "\(name) 생일"
        notificationContent.body = NotificationContentText.happyDay

        var dateComponents = DateComponents()
        dateComponents.month = date.dateComponentFromDate(component: DateComponent.month.rawValue)
        dateComponents.day = date.dateComponentFromDate(component: DateComponent.day.rawValue)
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        notificationCenter.add(request)
    }

    //MARK: - date to string
    func dateToString(date: Date, type: DateFormatterType) -> String {
        return date.dateToString(type: type)
    }
    
    //MARK: - 노티 지우기
    func removeNoti(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    //MARK: 이름
    //이름 비어있는지
    func checkName(name: String, text: String) -> Bool {
        return name == text ? true : false
    }
    
    //이름 겹치는지
    func checkNameEqual(petList: [String], name: String) -> Bool {
        return petList.contains(name) ? true : false
    }
    
    //MARK: 성별
    //성별 선택안했는지
    func checkGenderEmpty(gender: String) -> Bool {
        return gender == "" ? true : false
    }
    
    //MARK: 생일
    //생일입력안함
    func checkBirthdayEmpty(birthday: String) -> Bool {
        return birthday == "" ? true : false
    }
    
    //MARK: 사진
    //사진등록안함
    func checkProfileImageNil(image: Data?) -> Bool {
        return image == nil ? true : false
    }
    
    //MARK: - memory 펫 리스트 업데이트
    func updateMemoryPetList(memories: [UserMemory], currentName: String, newName: String) {
        memories.filter { $0.petList.contains(currentName) }.forEach {
            let tempPetList = List<String>()
            $0.petList.filter { $0 != currentName }.forEach { petName in
                tempPetList.append(petName)
            }
            tempPetList.append(newName)
            repository.updateMemoryPetList(item: $0, petList: tempPetList)
        }
    }
    
    
    //MARK: - UpdatePetInfo
    func updatePet(task: UserPet, profileImage: Data, name: String, birthday: Date, gender: String, comment: String) {
        repository.updatePet(item: task, profileImage: profileImage, name: name, birthday: birthday, gender: gender, comment: comment)
    }
    
    //MARK: - AddPet
    func addPet(item: UserPet) {
        repository.addPet(item: item)
    }
    
    //MARK: - dismissViewCheck
    func checkDismiss(gender: String, name: String, birthday: String, memo: String, image: Data?) -> Bool {
        
        if gender != "" || name != "" || birthday != "" || memo != "" || image != nil {
            return true
        } else {
            return false
        }
    }
    
}
