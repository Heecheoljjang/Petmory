//
//  PaddingLabel.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/10/05.
//

import UIKit

class PaddingLabel: UILabel {
    private let padding = UIEdgeInsets(top: 2, left: 0, bottom: 6, right: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        
        return contentSize
    }
}
