//
//  AllMemoryCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class AllMemoryCollectionViewCell: BasePetCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
