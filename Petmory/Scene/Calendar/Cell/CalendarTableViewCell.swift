//
//  CalendarTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import SnapKit

final class CalendarTableViewCell: BaseTableViewCell {
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 14)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 11)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CalendarTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [colorView, titleLabel, dateLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        colorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(8)
            make.height.equalTo(48)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(colorView).offset(-4)
            make.height.equalTo(20)
            make.trailing.lessThanOrEqualToSuperview()
            make.leading.equalTo(colorView.snp.trailing).offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(colorView)
            make.trailing.lessThanOrEqualToSuperview()
            make.leading.equalTo(titleLabel)
        }
    }
}
