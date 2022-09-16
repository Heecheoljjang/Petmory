//
//  WritingContentView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/16.
//

import UIKit
import SnapKit

final class WritingContentView: BaseView {
    
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
        view.font = UIFont(name: CustomFont.medium, size: 15)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        self.addSubview(textView)
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
