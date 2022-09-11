//
//  RegisterPetViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//

import Foundation
import UIKit

final class RegisterPetViewController: BaseViewController {
    
    var mainView = RegisterPetView()
    
    let repository = UserRepository()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUpController() {
        super.setUpController()
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(finishWriting))
        navigationItem.rightBarButtonItem = doneButton

    }
    
    //MARK: - @objc
    @objc private func finishWriting() {
        //데이터 저장
        
        let pet = UserPet(petName: mainView.nameTextField.text!, birthday: Date(), gender: true, comment: "123", registerDate: Date())
        repository.addPet(item: pet)
        
        transition(self, transitionStyle: .dismiss)
    }
}
