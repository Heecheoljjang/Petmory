//
//  SettingTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/22.
//

import UIKit
import SnapKit

final class SettingTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 15)
        
        return label
    }()
    
    let cellImage: UIImageView = {
        let view = UIImageView()
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SettingTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        addSubview(titleLabel)
        addSubview(cellImage)
        
        selectionStyle = .none
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        cellImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalTo(cellImage.snp.trailing).offset(12)
        }
    }
}
