//
//  AllMemoryTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import SnapKit

final class AllMemoryTableViewCell: BaseTableViewCell {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 10)
        label.textColor = .lightGray
        return label
    }()
    
    let memoryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        return label
    }()
    
    let memoryContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 12)
        label.textColor = .darkGray
        return label
    }()
    
    let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
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
        super.init(style: .default, reuseIdentifier: AllMemoryTableViewCell.identifier)
        
    }
    
    override func configure() {
        super.configure()
        
        stackView.addArrangedSubview(thumbnailImageView)
        
        [memoryContentLabel, memoryTitle, multiSign, dateLabel, stackView].forEach {
            self.addSubview($0)
        }
        
        selectionStyle = .none
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        //88
        memoryTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(stackView.snp.leading).offset(-20)
            make.top.equalTo(self).offset(12)
            make.height.equalTo(24)
        }
        
        memoryContentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(memoryTitle)
            make.top.equalTo(memoryTitle.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(memoryTitle)
            make.top.equalTo(memoryContentLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
            make.width.equalTo(80)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        multiSign.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.trailing.equalTo(thumbnailImageView).inset(4)
        }
    }
    
}
