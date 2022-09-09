//
//  AllMemoryCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class AllMemoryCollectionViewCell: BaseCollectionViewCell {
    
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
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        outerView.addSubview(nameLabel)
        self.addSubview(outerView)
    }
    
    override func setUpConstraints() {
        outerView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
