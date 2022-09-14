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
        view.backgroundColor = .systemGray5
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    let firstButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let thirdButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let fourthButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let fifthButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let sixthButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let seventhButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .customRedColor
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    //MARK: - Title
    let titleColorView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 18)
        textField.placeholder = "제목"
        
        return textField
    }()
    
    let titleTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - Date
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        return datePicker
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 16)
        textField.placeholder = "날짜 및 시간"
        return textField
    }()
    
    let dateTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - MemoTextView
    let memoTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: CustomFont.medium, size: 14)
        view.backgroundColor = .systemGray5
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
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        //MARK: - StackView
        let buttonSize = (self.frame.width - 48 - 40) / 7
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(buttonSize)
        }
        firstButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        secondButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        thirdButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        fourthButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        fifthButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        sixthButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        seventhButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.edges.equalToSuperview()
        }
        
        //MARK: - View
        
    }
}
