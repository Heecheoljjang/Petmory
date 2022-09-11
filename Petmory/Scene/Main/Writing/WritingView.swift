//
//  WritingView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class WritingView: BaseView {
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .red
        
        return textField
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [titleTextField, contentTextView].forEach {
            self.addSubview($0)
        }
        backgroundColor = .stringColor
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        titleTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleTextField)
            make.top.equalTo(titleTextField.snp.bottom).offset(100)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
