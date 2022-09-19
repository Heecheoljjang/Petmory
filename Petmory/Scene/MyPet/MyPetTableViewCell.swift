//
//  MyPetTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/19.
//

import UIKit
import SnapKit

final class MyPetTableViewCell: BaseTableViewCell {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 20)
        
        return label
    }()
    
//    let separatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .diaryColor
//        return view
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MyPetTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [profileImageView, nameLabel].forEach {
            self.addSubview($0)
        }
        
    }
    override func setUpConstraints() {
        super.setUpConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(40)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(profileImageView)
        }
        
//        separatorView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.height.equalTo(1)
//            make.bottom.equalToSuperview()
//        }
    }
}
