//
//  WritingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift
//import IQKeyboardManagerSwift
import PhotosUI

final class WritingViewController: BaseViewController {
    
    var mainView = WritingView()
    
    let repository = UserRepository()
    
    var petList: Results<UserPet>!
    
    var withList = List<String>()
    
//    var imageList = List<String>()
    
//    var imageArray: [UIImage] = [] {
//        didSet {
//            mainView.imageCollectionView.reloadData()
//        }
//    }
    var imageList = List<Data>() {
        didSet {
            print(imageList)
            mainView.imageCollectionView.reloadData()
            print("123")
        }
    }
    
    let placeholderText = "오늘 하루를 어떻게 보내셨나요?"
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList = repository.fetchPet()
        
        
    }
    
    override func setUpController() {
        super.setUpController()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishWriting))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelWriting))
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = Date().dateToString(type: .simple)
        
        //MARK: 액션 추가
        mainView.pickButton.addTarget(self, action: #selector(presentPhotoPickerView), for: .touchUpInside)
        
        //MARK: 텍스트뷰
        mainView.contentTextView.text = placeholderText
        mainView.contentTextView.textColor = .placeholderColor
        
        
        mainView.titleTextField.inputAccessoryView = UIView()
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.petCollectionView.delegate = self
        mainView.petCollectionView.dataSource = self
        mainView.contentTextView.delegate = self
        mainView.titleTextField.delegate = self
        
    }
    
    private func presentPHPickerViewController() {
        var configuartion = PHPickerConfiguration()
        configuartion.filter = .images
        
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        transition(picker, transitionStyle: .present)
    }
    
    //MARK: - @objc
    @objc private func finishWriting() {
        //데이터 저장
        mainView.petCollectionView.indexPathsForSelectedItems?.forEach {
            withList.append(petList[$0.item].petName)
        }
        print(withList)
        //이미지 저장
        
        let currentDate = Date()
        let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date().dateToString(type: .simple), petList: withList, memoryContent: mainView.contentTextView.text, imageData: imageList, objectId: "\(currentDate)")
        repository.addMemory(item: task)
        transition(self, transitionStyle: .dismiss)
//        if imageList.count == 0 {
//            let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date(), petList: withList, memoryContent: mainView.contentTextView.text, imageData: imageList, objectId: "\(currentDate)")
//            repository.addMemory(item: task)
//
//            transition(self, transitionStyle: .dismiss)
//        } else {
////            imageList.enumerated().forEach { (offset, image) in
////                saveImageToDocument(fileName: "\(currentDate)\(offset)", image: image)
////            }
//            let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date(), petList: withList, memoryContent: mainView.contentTextView.text, imageData: imageList, objectId: "\(currentDate)")
//            repository.addMemory(item: task)
//        }

        
    }
    @objc private func cancelWriting() {
        //alert띄워서 지울지말지 확인
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func presentPhotoPickerView() {
        print(imageList.count)
        if imageList.count <= 2 {
            presentPHPickerViewController()
        } else {
            print("No")
        }
    }
    
    //키보드
//    @objc func keyboardWillChange(_ sender: Notification) {
//
//        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        let keyboardHeight = keyboardFrame.cgRectValue.size.height
//
//        if mainView.frame.origin.y == 0 {
//            mainView.frame.origin.y = -(keyboardHeight)
//        }
//    }
//    @objc func keyboardWillHide(_ sender: Notification) {
//        mainView.frame.origin.y = 0
//    }
}
