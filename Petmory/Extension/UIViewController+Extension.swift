//
//  UIViewController+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/08.
//

import Foundation
import UIKit
import Zip
import RealmSwift

//MARK: - FileManager
extension UIViewController {
    
    //도큐먼트 폴더 url
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    //백업 확인용 파일 생성
    func createBackupCheckFile() {
        guard let documentDirectory = documentDirectoryPath() else { return }
        
        let filePath = documentDirectory.appendingPathComponent("PetmoryBackupCheck.txt")
        let testString = NSString(string: "Petmory")
        
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try testString.write(to: filePath, atomically: true, encoding: String.Encoding.utf8.rawValue)
            } catch {
                print("txt작성 실패")
            }
        }
    }
    
    //백업 확인용 디렉토리 생성
    func createCheckBackupDirectory() {
        guard let documentDirectory = documentDirectoryPath() else { return }
        
        let checkDirectoryPath = documentDirectory.appendingPathComponent("BackupCheck")
        
        if !FileManager.default.fileExists(atPath: checkDirectoryPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: checkDirectoryPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("확인 폴더 생성 실패")
            }
        }
    }
    
    //백업 확인용 파일 삭제
    func removeBackupCheckFile() {
        guard let documentDirectory = documentDirectoryPath() else { return }
        
        let filePath = documentDirectory.appendingPathComponent("PetmoryBackupCheck.txt")
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
            } catch {
                print("삭제 실패")
            }
        }
    }
    
    //잘못된 백업파일인 경우 삭제
    func removeBackupFile(fileName: URL) {
                
        if FileManager.default.fileExists(atPath: fileName.path) {
            do {
                try FileManager.default.removeItem(atPath: fileName.path)
            } catch {
                print("삭제 실패")
            }
        }
    }

    //MARK: - 백업/복구
    
    func deleteFileFromDocument(fileName: String) {
        guard let documentDirectory = documentDirectoryPath() else { return }
                
        let fileURL = documentDirectory.appendingPathComponent("\(fileName)")
        print("삭제할 url: \(fileURL)")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                noHandlerAlert(title: "삭제되었습니다.", message: "")
            } catch {
                noHandlerAlert(title: "삭제 중 오류가 발생하였습니다.", message: "")
            }
        } else {
            noHandlerAlert(title: "삭제하실 파일이 존재하지 않습니다.", message: "")
        }
    }
    
    func saveDataToDocument(data: Data, fileName: String) throws {
        guard let documentDirectory = documentDirectoryPath() else { throw ErrorType.documentPathError }
        
        let dataPath = documentDirectory.appendingPathComponent(fileName + ".json")
        print(dataPath)
        try data.write(to: dataPath)
    }
    
    func saveEncodedMemoryToDocument(data: Results<UserMemory>, fileName: String) throws {
        let encodeData = try encodeMemoryData(data: data)
        print("인코드:\(encodeData)")
        do {
            try saveDataToDocument(data: encodeData, fileName: fileName)
        } catch {
            throw ErrorType.savingFileError
        }
    }
    
    func saveEncodedCalendarToDocument(data: Results<UserCalendar>, fileName: String) throws {
        let encodeData = try encodeCalendarData(data: data)
        
        do {
            try saveDataToDocument(data: encodeData, fileName: fileName)
        } catch {
            throw ErrorType.savingFileError
        }
    }
    
    func saveEncodedPetToDocument(data: Results<UserPet>, fileName: String) throws {
        let encodeData = try encodePetData(data: data)
        
        do {
            try saveDataToDocument(data: encodeData, fileName: fileName)
        } catch {
            throw ErrorType.savingFileError
        }
    }
    
    //인코딩
    private func encodeMemoryData(data: Results<UserMemory>) throws -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(data)
            
            return encodedData
        } catch {
            throw ErrorType.encodingError
        }
    }
    private func encodeCalendarData(data: Results<UserCalendar>) throws -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(data)
            
            return encodedData
        } catch {
            throw ErrorType.encodingError
        }
    }
    private func encodePetData(data: Results<UserPet>) throws -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(data)
            
            return encodedData
        } catch {
            throw ErrorType.encodingError
        }
    }
    
    //디코딩
    //@discardableResult
    func decodeMemoryData(data: Data) throws -> [UserMemory]? {
        let decoder = JSONDecoder()
        
        do {
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode([UserMemory].self, from: data)
            
            return decodedData
        } catch {
            throw ErrorType.decodingError
        }
    }
    //@discardableResult
    func decodeCalendarData(data: Data) throws -> [UserCalendar]? {
        let decoder = JSONDecoder()
        
        do {
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode([UserCalendar].self, from: data)
            
            return decodedData
        } catch {
            throw ErrorType.decodingError
        }
    }
    //@discardableResult
    func decodePetData(data: Data) throws -> [UserPet]? {
        let decoder = JSONDecoder()
        
        do {
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode([UserPet].self, from: data)
            
            return decodedData
        } catch {
            throw ErrorType.decodingError
        }
    }
    
    //압축
    func zipBackupFile() throws -> URL {
        
        var urlPath: [URL] = []
        let fileName = "Petmory_\(Date().dateToString(type: .forBackupFile))"
        
        guard let documentDirectory = documentDirectoryPath() else { throw ErrorType.documentPathError }
        
        let memoryURL = documentDirectory.appendingPathComponent(BackupFileName.memory + ".json")
        let calendarURL = documentDirectory.appendingPathComponent(BackupFileName.calendar + ".json")
        let petURL = documentDirectory.appendingPathComponent(BackupFileName.pet + ".json")
        let backupCheckURL = documentDirectory.appendingPathComponent("PetmoryBackupCheck.txt")
        
        guard FileManager.default.fileExists(atPath: memoryURL.path) && FileManager.default.fileExists(atPath: calendarURL.path) && FileManager.default.fileExists(atPath: petURL.path) && FileManager.default.fileExists(atPath: backupCheckURL.path) else {
            throw ErrorType.pathAddingError
        }
        
        urlPath.append(contentsOf: [memoryURL, calendarURL, petURL, backupCheckURL])
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPath, fileName: fileName)
            print("zipFilePath: \(zipFilePath)")
            return zipFilePath
        } catch {
            throw ErrorType.zipError
        }
    }
    
    func unZipBackupFile(fileURL: URL, destination: URL) throws {

        do {
            try Zip.unzipFile(fileURL, destination: destination, overwrite: true, password: nil, progress: nil, fileOutputHandler: nil)
        } catch {
            throw ErrorType.unzipError
        }
    }
    
    //백업 파일 확인
    func checkBackupFile(fileURL: URL) throws -> Bool {
        //폴더 생성 후, 그 안에 압축 풀고 realm파일있는지 확인
        //있으면 alert띄우고 return true, 없으면 return false. 폴더도 지우기
        createCheckBackupDirectory()
        
        guard let documentDirectory = documentDirectoryPath() else { return false }
        
        let checkDirectoryPath = documentDirectory.appendingPathComponent("BackupCheck")
        
        let backupRealmFilePath = checkDirectoryPath.appendingPathComponent("default.realm")
        
        try unZipBackupFile(fileURL: fileURL, destination: checkDirectoryPath)
        
        if FileManager.default.fileExists(atPath: backupRealmFilePath.path) {
            removeBackupFile(fileName: checkDirectoryPath)
            return true
        } else {
            removeBackupFile(fileName: checkDirectoryPath)
            return false
        }
    }
    
    //복구
    func fetchJsonData(fileName: String) throws -> Data {
        guard let documentDirectory = documentDirectoryPath() else { throw ErrorType.documentPathError }
        
        let filePath = documentDirectory.appendingPathComponent(fileName + ".json")
        
        do {
            return try Data(contentsOf: filePath)
        } catch {
            throw ErrorType.fetchJsonDataError
        }
    }
    
    //백업 파일
    func checkBackupFileExist() -> Bool {
        guard let documentDirectory = documentDirectoryPath() else { return false }
                
        let checkFilePath = documentDirectory.appendingPathComponent("PetmoryBackupCheck.txt")
        
        if FileManager.default.fileExists(atPath: checkFilePath.path) {
            return true
        } else {
            return false
        }
    }

    //액티비티 컨트롤러
    func showActivityController(backupUrl: URL) {

        let vc = UIActivityViewController(activityItems: [backupUrl], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func fetchZipFile() -> [String] {
        guard let documentDirectory = documentDirectoryPath() else { return [] }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            let zipFiles = files.filter { $0.pathExtension == "zip" }
            let zipFileName = zipFiles.map { $0.lastPathComponent }
            return zipFileName.sorted(by: >)
        } catch {
            noHandlerAlert(title: "오류", message: "압축 파일을 가져오지 못했습니다.")
        }
        return []
    }
}

//MARK: - Transition

extension UIViewController {
    enum TransitionStyle {
        case present
        case presentModally
        case presentOver
        case presentNavigation
        case presentNavigationModally
        case push
        case pop
        case dismiss
    }
    
    func transition<T: UIViewController> (_ viewController: T, transitionStyle: TransitionStyle) {
        switch transitionStyle {
        case .present:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        case .presentModally:
            self.present(viewController, animated: true)
        case .presentOver:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .presentNavigationModally:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .dismiss:
            self.dismiss(animated: true)
        }
    }
}
//MARK: - Alert

extension UIViewController {
    func noHandlerAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func handlerAlert(title: String, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
