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
    
    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let photoButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "camera")
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .diaryColor
        
        button.configuration = configuration
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.diaryColor.cgColor
        button.layer.cornerRadius = 24
        
        return button
    }()
    
    let boyButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "남아"
        configuration.baseForegroundColor = .lightGray
        configuration.cornerStyle = .capsule
        
        button.configuration = configuration
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 24
        
        return button
    }()
    
    let girlButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = "여아"
        configuration.baseForegroundColor = .lightGray
        configuration.cornerStyle = .capsule
        
        button.configuration = configuration
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 24
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 :"
        label.font = UIFont(name: CustomFont.medium, size: 22)
        
        return label
    }()
    
    let nameLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .diaryColor
        
        return view
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 15)
        textField.textAlignment = .center

        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "생일 :"
        label.font = UIFont(name: CustomFont.medium, size: 22)

        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 15)
        textField.textAlignment = .center

        return textField
    }()
    
    let birthdayLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .diaryColor
        
        return view
    }()
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = UIFont(name: CustomFont.medium, size: 14)
        return label
    }()
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: CustomFont.medium, size: 15)
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .systemGray6
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [profileImageView, photoButton, nameLabel, nameLineView, nameTextField, birthdayLabel, birthdayLineView, birthdayTextField, memoLabel, memoTextView, boyButton, girlButton].forEach {
            self.addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.size.equalTo(160)
            make.centerX.equalToSuperview()
        }
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(profileImageView.snp.width).multipliedBy(0.3)
            make.bottom.trailing.equalTo(profileImageView)
//            make.center.equalTo(profileImageView)
        }
        boyButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(60)
            make.trailing.equalTo(girlButton.snp.leading).offset(-20)
        }
        girlButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(boyButton)
            make.width.equalTo(boyButton)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(boyButton.snp.bottom).offset(60)
            make.width.lessThanOrEqualTo(60)
        }
        nameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-20)
        }
        nameLineView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(nameLineView.snp.bottom).offset(60)
            make.width.lessThanOrEqualTo(60)
        }
        birthdayTextField.snp.makeConstraints { make in
            make.bottom.equalTo(birthdayLabel)
            make.leading.equalTo(birthdayLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-20)
        }
        birthdayLineView.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(4)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(birthdayLineView.snp.bottom).offset(60)
        }
        memoTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(memoLabel.snp.bottom).offset(12)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
    }
}
