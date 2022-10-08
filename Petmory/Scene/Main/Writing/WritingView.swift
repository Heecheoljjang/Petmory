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

    // 타이틀뷰
    let titleViewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 40))
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: ImageName.chevronDown)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        configuration.baseForegroundColor = .black
        
        button.configuration = configuration
        
        return button
    }()
    
    let titleViewDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        
        return datePicker
    }()
    
    //뷰
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(WritingImageCollectionViewCell.self, forCellWithReuseIdentifier: WritingImageCollectionViewCell.identifier)
        view.register(AddPhotoButtonCell.self, forCellWithReuseIdentifier: AddPhotoButtonCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return view
    }()

    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.font = UIFont(name: CustomFont.medium, size: 20)
        textField.placeholder = PlaceholderText.title
        textField.textAlignment = .center
        
        return textField
    }()
    
    let titleTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    let photoLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    let contentTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
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
        view.allowsMultipleSelection = true
        view.showsHorizontalScrollIndicator = false
        
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
                
        [imageCollectionView,titleTextFieldLineView, titleTextField, contentTextView, petCollectionView, withLabel, photoLineView].forEach {
            contentView.addSubview($0)
        }

        scrollView.addSubview(contentView)

        self.addSubview(scrollView)

        backgroundColor = .systemBackground
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.equalToSuperview()
            make.bottom.equalTo(scrollView).offset(10)
        }
        
        withLabel.snp.makeConstraints { make in

            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.height.equalTo(52)
        }
        
        petCollectionView.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.leading.equalTo(withLabel.snp.trailing).offset(12)
            make.height.equalTo(52)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
            make.top.equalTo(petCollectionView.snp.bottom)
        }

        photoLineView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(titleTextField)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(photoLineView.snp.bottom).offset(16)
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
            make.height.greaterThanOrEqualTo(200)
            make.bottom.equalToSuperview()
            
        }
        
    }
}
