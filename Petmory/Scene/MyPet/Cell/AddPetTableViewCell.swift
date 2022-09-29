//
//  AddPetTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/20.
//

import UIKit
import SnapKit

final class AddPetTableViewCell: BaseTableViewCell {
    
    let addButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .darkGray
        configuration.baseBackgroundColor = .veryLightGray
        //configuration.cornerStyle = .medium
        //configuration.image = UIImage(systemName: "plus")
        configuration.title = "반려동물 등록하기"
        
        //configuration.imagePlacement = .leading
        button.configuration = configuration
        button.layer.cornerRadius = 10
//        button.layer.borderColor = UIColor.systemGray6.cgColor
//        button.layer.borderWidth = 1
        button.clipsToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: AddPetTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        contentView.addSubview(addButton)
        //self.addSubview(addButton)
        self.selectionStyle = .none
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(48)
            make.verticalEdges.equalToSuperview().inset(20)
        }
    }
}
