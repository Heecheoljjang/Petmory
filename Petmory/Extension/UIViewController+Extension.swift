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
    func getDocumentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    //메모리 이미지 저장할 폴더 생성
    func createMemoryImageDirectory() {
        guard let documentDirectory = getDocumentDirectoryPath() else { return }
        
        let imageDirectory = documentDirectory.appendingPathComponent("images")
        
        if !FileManager.default.fileExists(atPath: imageDirectory.path) {
            do {
                try FileManager.default.createDirectory(atPath: imageDirectory.path, withIntermediateDirectories: true)
            } catch {
                print("이미지 폴더 생성 오류")
            }
        }
    }
    
    //이미지 저장(원본, 압축)
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = getDocumentDirectoryPath() else { return }
        
        let imageDirectory = documentDirectory.appendingPathComponent("images")
        let originalImageURL = imageDirectory.appendingPathComponent("\(fileName)") //원본
        
        guard let originalImageData = image.jpegData(compressionQuality: 1) else { return }
        
        do {
            try originalImageData.write(to: originalImageURL)
        } catch {
            print("이미지 저장 오류")
        }
    }
    
    //이미지 불러오기
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = getDocumentDirectoryPath() else { return nil }
        
        let imageDirectory = documentDirectory.appendingPathComponent("images")
        
        let imageURL = imageDirectory.appendingPathComponent("\(fileName)")
        if FileManager.default.fileExists(atPath: imageURL.path) {
            return UIImage(contentsOfFile: imageURL.path)
        } else {
            //디폴트 이미지 설정
            return nil
        }
    }
    
    //이미지 삭제
    func deleteImageFromDocument(fileName: String) {
        guard let documentDirectory = getDocumentDirectoryPath() else { return }
        
        let imageDirectory = documentDirectory.appendingPathComponent("images")
        
        let imageURL = imageDirectory.appendingPathComponent("\(fileName)")
        print("삭제할 url: \(imageURL)")
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("삭제 성공")
            } catch {
                print("파일 삭제 실패")
            }
        } else {
            print("지울 파일이 없습니다.")
        }
    }
    
    //백업 폴더 만들기
    func createBackupDirectory() {
        guard let documentDirectory = getDocumentDirectoryPath() else { return }
        
        let backupDirectory = documentDirectory.appendingPathComponent("backup")
        
        if !FileManager.default.fileExists(atPath: backupDirectory.path) {
            do {
                try FileManager.default.createDirectory(atPath: backupDirectory.path, withIntermediateDirectories: true)
            } catch {
                print("백업 폴더 생성 오류")
            }
        }
        
    }
    
    //MARK: - 백업/복구
    
    func saveDataToDocument(data: Data, fileName: String) throws {
        guard let documentDirectory = getDocumentDirectoryPath() else { throw ErrorType.documentPathError }
        
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
        
        guard let documentDirectory = getDocumentDirectoryPath() else { throw ErrorType.documentPathError }
        
        let memoryURL = documentDirectory.appendingPathComponent(BackupFileName.memory + ".json")
        let calendarURL = documentDirectory.appendingPathComponent(BackupFileName.calendar + ".json")
        let petURL = documentDirectory.appendingPathComponent(BackupFileName.pet + ".json")
        
        guard FileManager.default.fileExists(atPath: memoryURL.path) && FileManager.default.fileExists(atPath: calendarURL.path) && FileManager.default.fileExists(atPath: petURL.path) else {
            throw ErrorType.pathAddingError
        }
        
        urlPath.append(contentsOf: [memoryURL, calendarURL, petURL])
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPath, fileName: fileName)
            print("zipFilePath: \(zipFilePath)")
            return zipFilePath
        } catch {
            throw ErrorType.zipError
        }
    }
    
    func unZipBackupFile(fileURL: URL) throws {
        guard let documentDirectory = getDocumentDirectoryPath() else { throw ErrorType.documentPathError }
        
        do {
            try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: nil, fileOutputHandler: nil)
        } catch {
            throw ErrorType.unzipError
        }
    }
    
    //복구
    func fetchJsonData(fileName: String) throws -> Data {
        guard let documentDirectory = getDocumentDirectoryPath() else { throw ErrorType.documentPathError }
        
        let filePath = documentDirectory.appendingPathComponent(fileName + ".json")
        
        do {
            return try Data(contentsOf: filePath)
        } catch {
            throw ErrorType.fetchJsonDataError
        }
    }

    //액티비티 컨트롤러
    func showActivityController(backupUrl: URL) {

        let vc = UIActivityViewController(activityItems: [backupUrl], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func fetchZipFile() -> [String] {
        guard let documentDirectory = getDocumentDirectoryPath() else { return [] }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            let zipFiles = files.filter { $0.pathExtension == "zip" }
            let zipFileName = zipFiles.map { $0.lastPathComponent }
            return zipFileName.sorted(by: >)
        } catch {
            print("zip파일 가져오는데에서 오류")
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
