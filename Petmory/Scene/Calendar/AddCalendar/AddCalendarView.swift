//
//  AddCalendarView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import SnapKit

final class AddCalendarView: BaseView {
    
    //MARK: - Tag Color
    let stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.alignment = .fill
        view.layer.cornerRadius = 8
        view.spacing = 16
        return view
    }()
    
    let firstButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRed
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 0
        return button
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customPink
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 1
        return button
    }()
    
    let thirdButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customYellow
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 2
        return button
    }()
    
    let fourthButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customMint
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 3
        return button
    }()
    
    let fifthButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customGreen
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 4
        return button
    }()
    
    let sixthButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customBlue
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 5
        return button
    }()
    
    let seventhButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customPurple
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.tag = 6
        return button
    }()
    
    //MARK: - Title
    let titleColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .diaryColor
        return view
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 22)
        textField.placeholder = "제목"
        textField.sizeToFit()
        
        return textField
    }()
    
    let titleTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - Date
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.minuteInterval = 5
        datePicker.backgroundColor = .white
        
        return datePicker
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 17)
        textField.placeholder = "날짜 및 시간"
        textField.textAlignment = .center
        textField.tintColor = .clear
        return textField
    }()
    
    let dateTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - MemoTextView
    let memoTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: CustomFont.medium, size: 14)
        view.backgroundColor = .systemGray6
        view.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton, seventhButton].forEach {
            stackView.addArrangedSubview($0)
        }

        [stackView, titleColorView, titleTextField, titleTextFieldLineView, dateTextField, dateTextFieldLineView, memoTextView].forEach {
            self.addSubview($0)
        }
        
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()

        titleColorView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(titleTextField)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(4)
        }
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleColorView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(titleColorView)
        }
        titleTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleTextFieldLineView.snp.bottom).offset(60)
        }
        dateTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(dateTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(292)
            make.height.equalTo(28)
            make.top.equalTo(dateTextFieldLineView.snp.bottom).offset(40)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-40)
        }
    }
}
