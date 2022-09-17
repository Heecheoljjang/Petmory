//
//  MemoryDetailView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import SnapKit

final class MemoryDetailView: BaseView {
    
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
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(MemoryDetailImageCollectionViewCell.self, forCellWithReuseIdentifier: MemoryDetailImageCollectionViewCell.identifier)
        view.backgroundColor = .systemGray6
        view.isPagingEnabled = true
        view.layer.cornerRadius = 5
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 12)
        label.textAlignment = .center
        
        return label
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
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(MemoryDetailPetCollectionViewCell.self, forCellWithReuseIdentifier: MemoryDetailPetCollectionViewCell.identifier)
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
        
        [imageCollectionView, titleLabel, dateLabel, contentTextView, petCollectionView, withLabel].forEach {
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
        
        imageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(0.8)
            make.top.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageCollectionView)
            make.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        withLabel.snp.makeConstraints { make in
            //            make.leading.equalTo(self).offset(20)
            //            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.height.equalTo(52)
        }
        petCollectionView.snp.makeConstraints { make in
            make.top.equalTo(withLabel)
            make.trailing.equalToSuperview()
            //make.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(withLabel.snp.trailing).offset(12)
            make.height.equalTo(52)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleLabel)
            make.top.equalTo(withLabel.snp.bottom).offset(20)
            //make.height.greaterThanOrEqualTo(100)
            make.bottom.equalToSuperview()
        }
    }
}
