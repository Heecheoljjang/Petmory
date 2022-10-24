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
    
    var gender: Observable<String> = Observable("")
    
    var profileImage: Observable<Data?> = Observable(nil)
    
    var birthdayDate = Date()
    
    var currentStatus = CurrentStatus.new
    
    var task: UserPet?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var petList: [String] = []
    var memories: Results<UserMemory>!
    var currentName = ""
    
    func fetchPetAndMemory() {
        petList = repository.fetchPet().map { $0.petName }
        memories = repository.fetchAllMemory()
    }
    
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
        
    func setUpView(view: RegisterPetView, task: UserPet) {
        fetchPetAndMemory()
        view.addButton.configuration?.title = ButtonTitle.edit
        if let imageData = task.profileImage {
            profileImage.value = imageData
        }
        if task.gender == ButtonTitle.boy {
            gender.value = task.gender
        } else {
            gender.value = task.gender
        }
        view.nameTextField.text = task.petName
        currentName = task.petName
        
        if let birthdayDate = task.birthday {
            
        }
    }
    
    func checkNameTextField(view: RegisterPetView, text: String) -> Bool {
        if view.nameTextField.text! == text {
            return true
        } else {
            return false
        }
    }
    
    func checkProfileImageNil(view: RegisterPetView) -> Bool {
        if profileImage.value == nil {
            return true
        } else {
            return false
        }
    }
}
