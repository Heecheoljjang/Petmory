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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SettingTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        self.addSubview(titleLabel)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
