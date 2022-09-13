//
//  Repository.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/08.
//

import Foundation
import RealmSwift

protocol UserMemoryRepositoryType {
    
    func fetchMemory() -> Results<UserMemory>
    
    func fetchFiltered(name: String) -> Results<UserMemory>
    
    func fetchSearched(keyword: String) -> Results<UserMemory>
    
    func addMemory(item: UserMemory)
    
    func updateMemory(item: UserMemory, title: String, content: String, petList: List<String>)
    
    func deleteMemory(item: UserMemory)
}

protocol UserPetRepositoryType {
    
    func fetchPet() -> Results<UserPet>
    
    func addPet(item: UserPet)
    
    func updatePet(item: UserPet, name: String, birthday: Date, gender: Bool, comment: String)
    
    func deletePet(item: UserPet)
}

final class UserRepository: UserMemoryRepositoryType, UserPetRepositoryType {
    
    let localRealm = try! Realm()
    
    //MARK: - Memory
    
    //모아보기 첫 화면에 사용
    func fetchMemory() -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //모아보기 필터링
    func fetchFiltered(name: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).where {
            $0.petList.contains(name)
        }.sorted(byKeyPath: "memoryDate", ascending: false)
    }
    
    //검색화면
    func fetchSearched(keyword: String) -> Results<UserMemory> {
        return localRealm.objects(UserMemory.self).filter("memoryTitle CONTAINS[c] '\(keyword)' OR memoryContent CONTAINS[c] '\(keyword)'")
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
    
    func updateMemory(item: UserMemory, title: String, content: String, petList: List<String>) {
        do {
            try localRealm.write {
                item.memoryTitle = title
                item.memoryContent = content
                item.petList = petList
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
    
    //MARK: - Pet
    
    func fetchPet() -> Results<UserPet> {
        return localRealm.objects(UserPet.self).sorted(byKeyPath: "registerDate", ascending: false)
    }
    
    func addPet(item: UserPet) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch {
            print("펫 추가 오류")
        }
    }
    
    func updatePet(item: UserPet, name: String, birthday: Date, gender: Bool, comment: String) {
        do {
            try localRealm.write {
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
}
