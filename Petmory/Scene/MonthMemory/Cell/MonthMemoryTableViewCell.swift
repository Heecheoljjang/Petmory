//
//  MonthMemoryTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/28.
//

import UIKit
import SnapKit

final class MonthMemoryTableViewCell: BaseTableViewCell {
    
    let memoryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 18)
        
        return label
    }()
    
    let memoryContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 13)
        label.textColor = .lightGray
        
        return label
    }()
    
    let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        return view
    }()
    
    let multiSign: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "rectangle.fill.on.rectangle.angled.fill")
        view.backgroundColor = .clear
        view.tintColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MonthMemoryTableViewCell.identifier)
        
    }
    
    override func configure() {
        super.configure()
        
        [memoryContentLabel, memoryTitle, thumbnailImageView, multiSign].forEach {
            self.addSubview($0)
        }
        selectionStyle = .none
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        memoryTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(-20)
            make.top.equalTo(self).offset(12)
            make.height.equalTo(32)
        }
        
        memoryContentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(memoryTitle)
            make.top.equalTo(memoryTitle.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(memoryTitle)
            make.bottom.equalTo(memoryContentLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(64)
        }
        multiSign.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.trailing.equalTo(thumbnailImageView).inset(4)
        }
    }
}