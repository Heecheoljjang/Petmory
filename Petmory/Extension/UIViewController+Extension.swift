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
