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
    
    var indexPathForCell: IndexPath?
    
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
    
    override func configure() {
        super.configure()
        
        self.layer.cornerRadius = 5
        self.addSubview(deleteButton)
       // deleteButton.addTarget(self, action: #selector(foo), for: .touchUpInside)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        deleteButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self).offset(20)
            make.size.equalTo(44)
        }
    }
    
//    @objc private func foo() {
//
//        let writingViewController = WritingViewController()
//
//        if let indexPathForCell = indexPathForCell {
//            writingViewController.imageList.remove(at: indexPathForCell.item)
//            print("123")
//        }
//        writingViewController.mainView.imageCollectionView.reloadData()
//    }
}
