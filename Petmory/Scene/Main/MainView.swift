//
//  MainView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import SnapKit

final class MainView: BaseView {
    
    //MARK: 다이어리 뷰
    let outerView: UIView = {
        let view = UIView()
        view.backgroundColor = .diaryColor
        view.layer.cornerRadius = 3
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = UIColor.black.cgColor
        
        return view
    }()

    let stringView: UIView = {
        let view = UIView()
        view.backgroundColor = .stringColor
        
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.light, size: 18)
        label.textColor = .stringColor
        label.textAlignment = .center
        label.text = "2022.09.08"
        return label
    }()
    
    let dateLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 12)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "10페이지"

        return label
    }()
    
    let writingButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "pencil")
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .stringColor
        configuration.baseBackgroundColor = .diaryColor
    
        button.configuration = configuration
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize.zero
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        
        [stringView, dateLabel, dateLineView, pageLabel].forEach {
            outerView.addSubview($0)
        }
        
        [writingButton, outerView].forEach {
            self.addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        outerView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.height.equalTo(outerView.snp.width).multipliedBy(1.3)
            make.center.equalToSuperview()
        }
        
        stringView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(10)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(outerView.snp.width).multipliedBy(0.5)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        dateLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.width.equalTo(dateLabel).multipliedBy(1.1)
            make.centerX.equalTo(dateLabel)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(outerView.snp.top).offset(-12)
            make.centerX.equalTo(outerView)
        }
        
        writingButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
    }
}
