//
//  MonthMemoryCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/28.
//

import UIKit
import SnapKit

final class MonthMemoryCollectionViewCell: BasePetCollectionViewCell {
    
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
