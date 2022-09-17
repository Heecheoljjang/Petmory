//
//  WritingImageCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/12.
//

import Foundation
import UIKit
import SnapKit

final class WritingImageCollectionViewCell: BaseImageCollectionViewCell {
        
    let deleteButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")
        configuration.baseForegroundColor = .white

        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        deleteButton.removeTarget(nil, action: nil, for: .touchUpInside)
    }
    
    override func configure() {
        super.configure()
        
        self.layer.cornerRadius = 5
        self.addSubview(deleteButton)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        deleteButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self).offset(20)
            make.size.equalTo(44)
        }
    }

}
