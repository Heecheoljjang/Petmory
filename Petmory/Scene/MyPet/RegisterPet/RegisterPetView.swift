//
//  RegisterPetView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//

import Foundation
import UIKit
import SnapKit

final class RegisterPetView: BaseView {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemPink
        
        return view
    }()
    
    let photoButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "photo")
        
        button.configuration = configuration
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .red
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        self.addSubview(nameTextField)
        backgroundColor = .stringColor
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
}
