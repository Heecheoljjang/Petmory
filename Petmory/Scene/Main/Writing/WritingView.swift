//
//  WritingView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class WritingView: BaseView {
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(WritingImageCollectionViewCell.self, forCellWithReuseIdentifier: WritingImageCollectionViewCell.identifier)
        view.isPagingEnabled = true
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    let pickButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .diaryColor
        configuration.baseBackgroundColor = .stringColor
        configuration.image = UIImage(systemName: "photo")
        
        button.configuration = configuration
        return button
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .red
        textField.font = UIFont(name: CustomFont.medium, size: 20)
        textField.placeholder = "제목"
        
        return textField
    }()
    
    let titleTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .diaryColor
        view.isScrollEnabled = false
        view.font = UIFont(name: CustomFont.medium, size: 15)
        return view
    }()
    
    let petCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 8
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(WritingPetCollectionViewCell.self, forCellWithReuseIdentifier: WritingPetCollectionViewCell.identifier)
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    let withLabel: UILabel = {
        let label = UILabel()
        label.text = "with"
        label.font = UIFont(name: CustomFont.bold, size: 15)
    
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
                
        [imageCollectionView, pickButton, titleTextFieldLineView, titleTextField, contentTextView, petCollectionView, withLabel].forEach {
            contentView.addSubview($0)
        }
    
        scrollView.addSubview(contentView)
        
        self.addSubview(scrollView)
        backgroundColor = .stringColor
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        withLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.top.equalToSuperview()
            make.height.equalTo(52)
        }
        
        petCollectionView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(withLabel.snp.trailing).offset(12)
            make.height.equalTo(52)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(0.8)
            make.top.equalTo(petCollectionView.snp.bottom).offset(20)
        }
        
        pickButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.bottom.trailing.equalTo(imageCollectionView).offset(-12)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        titleTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalTo(titleTextField)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleTextField)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(100)
            make.bottom.equalToSuperview()
        }
        
    }
}
