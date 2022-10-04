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

final class UserRepository: UserMemoryRepositoryType, UserPetRepositoryType, UserCalendarRepositoryType {
    
    let localRealm = try! Realm()
    
    //MARK: - Memory
    
    //모아보기 첫 화면에 사용
    func fetchTodayMemory() -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryDateString == '\(Date().dateToString(type: .simple))'").sorted(byKeyPath: "memoryTitle", ascending: true)
    }
    
    func fetchAllMemory() -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    func fetchWithObjectId(objectId: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("objectId == '\(objectId)'")
    }
    
    //모아보기 필터링
    func fetchFiltered(name: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).where {
            $0.petList.contains(name)
        }.sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //날짜별 데이터
    func fetchDateFiltered(dateString: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryDateString CONTAINS[c] '\(dateString)'").sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //검색화면
    func fetchSearched(keyword: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryTitle CONTAINS[c] '\(keyword)' OR memoryContent CONTAINS[c] '\(keyword)'").sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //기록 추가
    func addMemory(item: UserMemory) {
        
        do {
            try localRealm.write {
                localRealm.add(item)
                print(localRealm.configuration.fileURL!)
            }
        } catch {
            print("기록 추가 오류")
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
            print("기록 수정 오류")
        }
    }
    
    func deleteMemory(item: UserMemory) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("기록 삭제 오류")
        }
    }
    
    func deleteAllMemory(task: Results<UserMemory>) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            print("기록 전체 삭제 오류")
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
            print("펫 추가 오류")
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
            print("펫 수정 오류")
        }
    }
    
    func deletePet(item: UserPet) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("펫 삭제 오류")
        }
    }
    
    func deleteAllPet(task: Results<UserPet>) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            print("펫 전체 삭제 오류")
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
            print("일정 저장 오류")
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
            print("펫 수정 오류")
        }
    }
    
    func deleteCalendar(item: UserCalendar) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("일정 삭제 오류")
        }
    }
    
    func deleteAllCalendar(task: Results<UserCalendar>) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            print("일정 전체 삭제 오류")
        }
    }
}
