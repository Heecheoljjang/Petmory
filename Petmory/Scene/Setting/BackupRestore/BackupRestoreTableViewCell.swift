//
//  BackupRestoreTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/27.
//

import UIKit
import SnapKit

final class BackupRestoreTableViewCell: BaseTableViewCell {
    
    let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 11)
        label.textColor = .darkGray
        return label
    }()
    
    let fileImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: ImageName.file)
        view.tintColor = .darkGray
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: BackupRestoreTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        [fileNameLabel, fileImage].forEach {
            addSubview($0)
        }
        selectionStyle = .none
        backgroundColor = .veryLightGray
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        fileImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(fileImage.snp.height)
        }
        
        fileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(fileImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
}
