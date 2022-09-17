//
//  MemoryDetailPetCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/17.
//

import UIKit

final class MemoryDetailPetCollectionViewCell: BasePetCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        nameLabel.textColor = .lightGray
        outerView.layer.borderWidth = 0
    }
}
