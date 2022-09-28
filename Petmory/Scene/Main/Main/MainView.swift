//
//  MainView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import SnapKit

final class MainView: BaseView {
    
    let diaryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.minimumLineSpacing = 40
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        
        view.backgroundColor = .white
        
        
        
        return view
    }()
    
    //MARK: 작성 버튼
    let writingButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "pencil")
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .stringColor
        configuration.baseBackgroundColor = .diaryColor
    
        button.configuration = configuration
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize.zero
        
        return button
    }()
    
    //MARK: 안내 문구
    let zeroContentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "사랑하는 반려동물과의\n\n소중한 하루를 기록해보세요 :)"
        label.font = UIFont(name: CustomFont.medium, size: 13)
        label.textColor = .lightGray
        
        return label
    }()
    
//    let tapLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.text = "오늘 작성한 기록들을 확인해보세요 :)"
//        label.font = UIFont(name: CustomFont.medium, size: 12)
//        label.textColor = .lightGray
//        
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
    
//        [diaryCollectionView, writingButton, zeroContentsLabel].forEach {
//            addSubview($0)
//        }
        
        [diaryCollectionView, writingButton].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        
        diaryCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-28)
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(44)
            //make.bottom.equalTo(writingButton.snp.top).offset(-40)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(420)
        }
        
        writingButton.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
//        tapLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(diaryCollectionView.snp.top).offset(-40)
//        }
//
//        zeroContentsLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
//            make.bottom.equalTo(diaryCollectionView.snp.top).offset(20)
//        }
//
    }
}
