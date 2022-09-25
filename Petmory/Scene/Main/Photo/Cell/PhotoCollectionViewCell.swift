//
//  PhotoCollectionViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/26.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(photoImageView)
        backgroundColor = .black
    }
    
    func setUpConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
