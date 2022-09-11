//
//  MyPetViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift

final class MyPetViewController: BaseViewController {
    
    var mainView = MyPetView()
    
    let repository = UserRepository()
    
    var tasks: Results<UserPet>! {
        didSet {
            print("\(tasks.count)")
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpController() {
        super.setUpController()
        
        let tempAddButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(presentRegisterPetView))
        navigationItem.rightBarButtonItem = tempAddButton
    }
    
    //MARK: - @objc
    @objc private func presentRegisterPetView() {
//        let task = UserPet(petName: "윤희철", birthday: Date(), gender: true, comment: "좋아요", registerDate: Date())
//        repository.addPet(item: task)
//
//        tasks = repository.fetch()
        transition(RegisterPetViewController(), transitionStyle: .presentNavigation)
    }
}
