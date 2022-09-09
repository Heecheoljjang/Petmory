//
//  BaseView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/07.
//

import Foundation
import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpContraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func configure() {}
    
    func setUpContraints() {}
    
}
