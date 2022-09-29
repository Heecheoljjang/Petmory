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
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
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
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    let titleTextFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()

    let contentTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
        view.isScrollEnabled = false
        view.font = UIFont(name: CustomFont.medium, size: 15)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        stackView.addArrangedSubview(imageCollectionView)

        [stackView, titleLabel, titleTextFieldLineView, contentTextView].forEach {
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
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(0.8)
            make.top.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageCollectionView)
            make.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        titleTextFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(titleLabel)
        }

        contentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleLabel)
            make.top.equalTo(titleTextFieldLineView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}
