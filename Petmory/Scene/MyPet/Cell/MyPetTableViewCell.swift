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
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 20)
        
        return label
    }()
    
    let deleteView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MyPetTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [profileImageView, nameLabel].forEach {
            self.addSubview($0)
        }
        selectionStyle = .none
    }
    override func setUpConstraints() {
        super.setUpConstraints()
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(40)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(32)
        }
    }
}
