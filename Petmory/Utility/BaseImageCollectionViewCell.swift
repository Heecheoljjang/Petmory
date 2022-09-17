//
//  BaseCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

class BaseImageCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 5
        //view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.addSubview(photoImageView)
        
    }
    
    func setUpConstraints() {
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
