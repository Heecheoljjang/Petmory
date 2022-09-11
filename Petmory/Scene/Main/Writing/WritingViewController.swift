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
        
    }
    
    //MARK: - @objc
    @objc private func finishWriting() {
        //데이터 저장
        
        let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date(), petList: withList, memoryContent: mainView.contentTextView.text)
        repository.addMemory(item: task)
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func cancelWriting() {
        //alert띄워서 지울지말지 확인
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func presentPhotoPickerView() {
        
    }
}
