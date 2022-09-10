//
//  TodayListTableViewCell.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class TodayListTableViewCell: BaseTableViewCell {
    
    let outerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.diaryColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    let mainImageView: UIImageView = {
        let view = UIImageView()
        
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 18)
        
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.light, size: 13)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: TodayListTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [mainImageView, titleLabel, contentLabel].forEach {
            outerView.addSubview($0)
        }
        self.addSubview(outerView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        outerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.verticalEdges.equalToSuperview().inset(12)
            make.width.equalTo(mainImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.top).offset(12)
            make.leading.equalTo(mainImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(mainImageView.snp.bottom).offset(-12)
            make.leading.equalTo(mainImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
}
