//
//  AddPhotoButtonCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/29.
//

import UIKit
import SnapKit

final class AddPhotoButtonCell: BaseCollectionViewCell {
    
    let addButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .darkGray
        configuration.baseBackgroundColor = .veryLightGray
        configuration.cornerStyle = .medium
        configuration.image = UIImage(systemName: "camera")
        
        button.configuration = configuration
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        contentView.addSubview(addButton)
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
