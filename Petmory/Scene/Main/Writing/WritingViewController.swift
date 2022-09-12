//
//  WritingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import PhotosUI

final class WritingViewController: BaseViewController {
    
    var mainView = WritingView()
    
    let repository = UserRepository()
    
    var petList: Results<UserPet>!
    
    var withList = List<String>()
    
    var petIsSelected = [Bool]() {
        didSet {
            print(petIsSelected)
        }
    }
    
    var imageList: [Data] = []
    
    let placeholderText = "오늘 하루를 어떻게 보내셨나요?"
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList = repository.fetchPet()
        
        IQKeyboardManager.shared.enable = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        petIsSelected = [Bool](repeating: true, count: petList.count)
    }
    
    override func setUpController() {
        super.setUpController()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishWriting))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelWriting))
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        title = Date().dateToString()
        
        //MARK: 액션 추가
        mainView.pickButton.addTarget(self, action: #selector(presentPhotoPickerView), for: .touchUpInside)
        
        //MARK: 텍스트뷰
        mainView.contentTextView.text = placeholderText
        mainView.contentTextView.textColor = .placeholderColor
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.petCollectionView.delegate = self
        mainView.petCollectionView.dataSource = self
        mainView.contentTextView.delegate = self
        
    }
    
    private func presentPHPickerViewController() {
        var configuartion = PHPickerConfiguration()
        configuartion.selectionLimit = 3
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
        
        let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date(), petList: withList, memoryContent: mainView.contentTextView.text)
        repository.addMemory(item: task)
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func cancelWriting() {
        //alert띄워서 지울지말지 확인
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func presentPhotoPickerView() {
        
        presentPHPickerViewController()
    }
}
