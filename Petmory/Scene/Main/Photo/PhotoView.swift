//
//  PhotoView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/26.
//

import UIKit
import SnapKit

final class PhotoView: BaseView {
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        view.backgroundColor = .black
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        
        
        return pageControl
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: ImageName.xmark)
        configuration.baseForegroundColor = .white
        
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [imageCollectionView, pageControl, dismissButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        imageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
}
