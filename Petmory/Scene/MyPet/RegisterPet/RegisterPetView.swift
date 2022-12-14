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
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = ButtonTitle.delete
        configuration.baseForegroundColor = .diaryColor
        configuration.baseBackgroundColor = .white
        
        button.configuration = configuration
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.diaryColor.cgColor
        button.clipsToBounds = true
        
        return button
    }()
    let addButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = ButtonTitle.register
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .diaryColor
        
        button.configuration = configuration
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    
    let profileImageView: UIImageView = {
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
        configuration.image = UIImage(systemName: ImageName.camera)
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .diaryColor
        
        button.configuration = configuration
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.diaryColor.cgColor
        button.layer.cornerRadius = 24
        
        return button
    }()
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.text = LabelText.memo
        label.font = UIFont(name: CustomFont.medium, size: 14)
        return label
    }()
    
    let boyButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = ButtonTitle.boy
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
        configuration.title = ButtonTitle.girl
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
        label.text = LabelText.nameWithColon
        label.font = UIFont(name: CustomFont.medium, size: 18)
        
        return label
    }()
    
    let nameLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .diaryColor
        
        return view
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 18)
        textField.textAlignment = .center
        textField.placeholder = PlaceholderText.writeName
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = LabelText.birthDayWithColon
        label.font = UIFont(name: CustomFont.medium, size: 18)

        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 18)
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.placeholder = PlaceholderText.selectBirthday
        return textField
    }()
    
    let birthdayLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .diaryColor
        
        return view
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = LabelText.gender
        label.font = UIFont(name: CustomFont.medium, size: 14)
        return label
    }()
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: CustomFont.medium, size: 15)
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .systemGray6
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        
        return textView
    }()
    
    let birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        
        return datePicker
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = NavigationTitleLabel.registerPet
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        scrollView.addSubview(contentView)
        
        [deleteButton, addButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [profileImageView, photoButton, nameLabel, nameLineView, nameTextField, birthdayLabel, birthdayLineView, birthdayTextField, memoLabel, memoTextView, boyButton, girlButton, stackView].forEach {
            contentView.addSubview($0)
        }
        
        self.addSubview(scrollView)
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.equalToSuperview()
            make.bottom.equalTo(scrollView).offset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.size.equalTo(160)
            make.centerX.equalToSuperview()
        }
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(profileImageView.snp.width).multipliedBy(0.3)
            make.bottom.trailing.equalTo(profileImageView)
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
            make.bottom.equalTo(nameLineView.snp.top)
            make.centerY.equalTo(nameLabel)
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
            make.height.equalTo(140)
        }
        stackView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-80)
            make.top.equalTo(memoTextView.snp.bottom).offset(36)
        }
    }
}
