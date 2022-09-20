//
//  SearchResultTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class SearchResultTableViewCell: BaseTableViewCell {
    
    let memoryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 18)
        
        return label
    }()
    
    let memoryDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 13)
        label.textColor = .lightGray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SearchResultTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [memoryDate, memoryTitle].forEach {
            self.addSubview($0)
        }
        backgroundColor = .stringColor
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        memoryTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(32)
        }
        
        memoryDate.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(memoryTitle)
            make.top.equalTo(memoryTitle.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
