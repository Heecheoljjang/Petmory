//
//  MainViewModel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/30.
//

import Foundation
import RealmSwift
import UserNotifications

final class MainViewModel {
    
    let repository = UserRepository()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var tasks: Observable<Results<UserMemory>?> = Observable(nil)
    
    var petList: Observable<Results<UserPet>?> = Observable(nil)
    
    let monthList = [". 01", ". 02", ". 03", ". 04", ". 05", ". 06", ". 07", ". 08", ". 09", ". 10", ". 11", ". 12"]
    
    var tempList: Observable<[String]> = Observable([])
    
    var selectedDate: Observable<String> = Observable("")
    
    var currentYear: Observable<String> = Observable("")
    
    var countList: Observable<[Int]> = Observable([])
    
    let yearList = [Int](1990...2050)
    
    var isFirst: Observable<Bool> = Observable(true)
    
    func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            if success == true {
                print("성공")
            } else {
                print("실패")
            }
        }
    }
    
    func setCurrentYear() {
        currentYear.value = Date().dateToString(type: .onlyYear)
    }
    
    func fetchAllMemory() {
        tasks.value = repository.fetchAllMemory()
    }
    
    func fetchPet() {
        petList.value = repository.fetchPet()
    }
    
    func checkPetCount() -> Bool {
        return petList.value?.count == 0 ? true : false
    }
    
    func setCountList() {
        
        countList.value = []
        
        guard let memory = tasks.value else { return }
        
        tempList.value.forEach { date in
            countList.value.append(memory.filter("\(RealmModelColumn.memoryDateString) CONTAINS[c] '\(date)'").count)
        }
    }
    
    func setTempList() {
        
        tempList.value = monthList
        for i in 0..<monthList.count {
            tempList.value[i] = currentYear.value + monthList[i]
        }
    }
    
    func setSelectedDate(date: String) {
        selectedDate.value = date
    }
}
