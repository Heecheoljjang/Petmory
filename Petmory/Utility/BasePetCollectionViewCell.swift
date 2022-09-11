//
//  BasePetCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/12.
//

import Foundation
import UIKit
import SnapKit

class BasePetCollectionViewCell: UICollectionViewCell {
    
    let outerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.diaryColor.cgColor
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 13)
        label.textColor = .diaryColor
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        outerView.addSubview(nameLabel)
        self.addSubview(outerView)
    }
    
    func setUpConstraints() {
        outerView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.width.greaterThanOrEqualTo(24)
            make.height.equalTo(40)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                outerView.backgroundColor = .diaryColor
                nameLabel.textColor = .stringColor
            } else {
                outerView.backgroundColor = .systemBackground
                nameLabel.textColor = .diaryColor
            }
        }
    }
}
