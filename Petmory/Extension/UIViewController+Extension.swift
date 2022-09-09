//
//  UIViewController+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/08.
//

import Foundation
import UIKit

//MARK: - FileManager
extension UIViewController {
    
    //도큐먼트 폴더 url
    func getDocumentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    //이미지 저장할 폴더 생성
    func createImageDirectory() {
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
        let originalImageURL = imageDirectory.appendingPathComponent("\(fileName)Original") //원본
        let compressedImageURL = imageDirectory.appendingPathComponent("\(fileName)Compressed") //압축
        
        guard let originalImageData = image.jpegData(compressionQuality: 1) else { return }
        guard let compressedImageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        do {
            try originalImageData.write(to: originalImageURL)
            try compressedImageData.write(to: compressedImageURL)
        } catch {
            print("이미지 저장 오류")
        }
    }
    
    //이미지 불러오기
    func loadImageFromDocument(fileName: String, isOriginal: Bool) -> UIImage? {
        guard let documentDirectory = getDocumentDirectoryPath() else { return nil }
        
        let imageDirectory = documentDirectory.appendingPathComponent("images")
        if isOriginal == true {
            let imageURL = imageDirectory.appendingPathComponent("\(fileName)Original")
            if FileManager.default.fileExists(atPath: imageURL.path) {
                return UIImage(contentsOfFile: imageURL.path)
            } else {
                //디폴트 이미지 설정
                return nil
            }
        } else {
            let imageURL = imageDirectory.appendingPathComponent("\(fileName)Compressed")
            if FileManager.default.fileExists(atPath: imageURL.path) {
                return UIImage(contentsOfFile: imageURL.path)
            } else {
                //디폴트 이미지 설정
                return nil
            }
        }
    }
}
