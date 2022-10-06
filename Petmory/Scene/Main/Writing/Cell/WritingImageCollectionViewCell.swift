//
//  WritingImageCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/12.
//

import Foundation
import UIKit
import SnapKit

final class WritingImageCollectionViewCell: BaseCollectionViewCell {
        
    let deleteButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "xmark")
        configuration.baseForegroundColor = .veryLightGray
        configuration.baseBackgroundColor = .darkGray
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 11)

        button.configuration = configuration
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.backgroundColor = .white
        return button
    }()
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
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
        [photoImageView, deleteButton].forEach {
            addSubview($0)
        }
    }
    override func setUpContraints() {
        super.setUpContraints()
        
        photoImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(photoImageView).offset(10)
            make.top.equalTo(photoImageView).offset(-10)
            make.size.equalTo(28)
        }
    }

}
