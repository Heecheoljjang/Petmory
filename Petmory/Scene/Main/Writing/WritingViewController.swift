//
//  WritingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift

final class WritingViewController: BaseViewController {
    
    var mainView = WritingView()
    
    let repository = UserRepository()
    
    var petList: List<String> = List<String>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList.append("아아아아아")
        petList.append("호호")
        petList.append("윤희철")
        petList.append("짱")
        petList.append("안녕안녕나는윤희철")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setUpController() {
        super.setUpController()
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(finishWriting))
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelWriting))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    //MARK: - @objc
    @objc private func finishWriting() {
        //데이터 저장
        
        let task = UserMemory(memoryTitle: "바보바보", memoryDate: Date(), petList: petList, memoryContent: "안녕 나는 윤희철 반가워 가나다라마바사아자차카타파하 오호호호호호호호호홓호호")
        repository.addMemory(item: task)
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func cancelWriting() {
        //alert띄워서 지울지말지 확인
        
        transition(self, transitionStyle: .dismiss)
    }
}
