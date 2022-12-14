//
//  Repository.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/08.
//

import UIKit
import RealmSwift

protocol UserMemoryRepositoryType {
    
    func fetchAllMemory() -> Results<UserMemory>
    
    func fetchTodayMemory() -> Results<UserMemory>

    func fetchWithObjectId(objectId: String) -> Results<UserMemory>
    
    func fetchFiltered(name: String) -> Results<UserMemory>
    
    func fetchDateFiltered(dateString: String) -> Results<UserMemory>
    
    func fetchSearched(keyword: String) -> Results<UserMemory>
    
    func addMemory(item: UserMemory)
    
    func updateMemory(item: UserMemory, title: String, memoryDateString: String, content: String, petList: List<String>, imageData: List<Data>, memoryDate: Date)
    
    func deleteMemory(item: UserMemory)
    
    func deleteAllMemory(task: Results<UserMemory>)
}

protocol UserPetRepositoryType {
    
    func fetchPet() -> Results<UserPet>
    
    func addPet(item: UserPet)
    
    func updatePet(item: UserPet, profileImage: Data?, name: String, birthday: Date, gender: String, comment: String)
    
    func deletePet(item: UserPet)
    
    func deleteAllPet(task: Results<UserPet>)
}

protocol UserCalendarRepositoryType {
    
    func fetchAllCalendar() -> Results<UserCalendar>
    
    func fetchCalendar(date: Date) -> Results<UserCalendar>
    
    func addCalendar(item: UserCalendar)
    
    func updateCalendar(item: UserCalendar, title: String, date: Date, dateString: String, color: String, comment: String)
    
    func deleteCalendar(item: UserCalendar)
    
    func deleteAllCalendar(task: Results<UserCalendar>)
}

protocol CommonRepositoryType {
    
    func deleteAll(memory: Results<UserMemory>, calendar: Results<UserCalendar>, pet: Results<UserPet>)
    
    func addAll(memory: [UserMemory], calendar: [UserCalendar], pet: [UserPet])
    
}

final class UserRepository: UserMemoryRepositoryType, UserPetRepositoryType, UserCalendarRepositoryType, CommonRepositoryType {
    
    let localRealm = try! Realm()
    
    //MARK: - Common
    
    func deleteAll(memory: Results<UserMemory>, calendar: Results<UserCalendar>, pet: Results<UserPet>) {
        
        deleteAllMemory(task: memory)
        deleteAllCalendar(task: calendar)
        deleteAllPet(task: pet)
    }
    
    func addAll(memory: [UserMemory], calendar: [UserCalendar], pet: [UserPet]) {
        
        localRealm.add(memory)
        localRealm.add(calendar)
        localRealm.add(pet)
    }
    
    //MARK: - Memory
    
    //???????????? ??? ????????? ??????
    func fetchTodayMemory() -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryDateString == '\(Date().dateToString(type: .simple))'").sorted(byKeyPath: "memoryTitle", ascending: true)
    }
    
    func fetchAllMemory() -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    func fetchWithObjectId(objectId: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("objectId == '\(objectId)'")
    }
    
    //???????????? ?????????
    func fetchFiltered(name: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).where {
            $0.petList.contains(name)
        }.sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //????????? ?????????
    func fetchDateFiltered(dateString: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryDateString CONTAINS[c] '\(dateString)'").sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //????????????
    func fetchSearched(keyword: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryTitle CONTAINS[c] '\(keyword)' OR memoryContent CONTAINS[c] '\(keyword)'").sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //?????? ??????
    func addMemory(item: UserMemory) {
        
        do {
            try localRealm.write {
                localRealm.add(item)
                print(localRealm.configuration.fileURL!)
            }
        } catch {
            print("?????? ?????? ??????")
        }
    }
    
    func updateMemory(item: UserMemory, title: String, memoryDateString: String, content: String, petList: List<String>, imageData: List<Data>, memoryDate: Date) {
        do {
            try localRealm.write {
                item.memoryTitle = title
                item.memoryDateString = memoryDateString
                item.memoryContent = content
                item.petList = petList
                item.imageData = imageData
                item.memoryDate = memoryDate
            }
        } catch {
            print("?????? ?????? ??????")
        }
    }
    
    //???????????? ????????? ????????????
    func updateMemoryPetList(item: UserMemory, petList: List<String>) {
        do {
            try localRealm.write {
                item.petList = petList
            }
        } catch {
            print("???????????? ????????? ?????? ??????")
        }
    }
    
    func deleteMemory(item: UserMemory) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("?????? ?????? ??????")
        }
    }
    
    func deleteAllMemory(task: Results<UserMemory>) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            print("?????? ?????? ?????? ??????")
        }
    }
    
    //MARK: - Pet
    
    func fetchPet() -> Results<UserPet> {
        return localRealm.objects(UserPet.self).sorted(byKeyPath: "registerDate", ascending: false)
    }
    
    func addPet(item: UserPet) {
        do {
            try localRealm.write {
                localRealm.add(item)
                print(localRealm.configuration.fileURL!)
            }
        } catch {
            print("??? ?????? ??????")
        }
    }
    
    func updatePet(item: UserPet, profileImage: Data?, name: String, birthday: Date, gender: String, comment: String) {
        do {
            try localRealm.write {
                item.profileImage = profileImage
                item.petName = name
                item.birthday = birthday
                item.gender = gender
                item.comment = comment
            }
        } catch {
            print("??? ?????? ??????")
        }
    }
    
    func deletePet(item: UserPet) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("??? ?????? ??????")
        }
    }
    
    func deleteAllPet(task: Results<UserPet>) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            print("??? ?????? ?????? ??????")
        }
    }
    
    //MARK: - Calendar
    
    func fetchAllCalendar() -> Results<UserCalendar> {
        
        return localRealm.objects(UserCalendar.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    func fetchCalendar(date: Date) -> Results<UserCalendar> {
        
        return localRealm.objects(UserCalendar.self).filter("dateString == '\(date.dateToString(type: .simple))'").sorted(byKeyPath: "date", ascending: true)
    }
    
    func addCalendar(item: UserCalendar) {
        do {
            try localRealm.write {
                localRealm.add(item)
                print(localRealm.configuration.fileURL!)
            }
        }catch {
            print("?????? ?????? ??????")
        }
    }
    
    func updateCalendar(item: UserCalendar, title: String, date: Date, dateString: String, color: String, comment: String) {
        do {
            try localRealm.write {
                item.title = title
                item.date = date
                item.color = color
                item.comment = comment
                item.dateString = dateString
            }
        } catch {
            print("??? ?????? ??????")
        }
    }
    
    func deleteCalendar(item: UserCalendar) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("?????? ?????? ??????")
        }
    }
    
    func deleteAllCalendar(task: Results<UserCalendar>) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            print("?????? ?????? ?????? ??????")
        }
    }
}
