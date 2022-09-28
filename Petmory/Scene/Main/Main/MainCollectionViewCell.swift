//
//  MainCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/28.
//

import UIKit
import SnapKit

final class MainCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: 다이어리 뷰
    let outerView: UIView = {
        let view = UIView()
        view.backgroundColor = .diaryColor
        view.layer.cornerRadius = 3
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.5
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
        label.font = UIFont(name: CustomFont.medium, size: 18)
        label.textColor = .stringColor
        label.textAlignment = .center
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

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [stringView, dateLabel, dateLineView, pageLabel].forEach {
            outerView.addSubview($0)
        }
        
        addSubview(outerView)
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        outerView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(360)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
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
            make.bottom.equalTo(outerView.snp.bottom).offset(32)
            make.centerX.equalTo(outerView)
        }
    }
}
