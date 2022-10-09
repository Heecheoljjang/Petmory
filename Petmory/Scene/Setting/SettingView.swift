//
//  SettingView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/20.
//

import UIKit
import SnapKit

final class SettingView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.isScrollEnabled = false
        return view
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 15)
        label.textColor = .lightGray
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = NavigationTitleLabel.setting
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [tableView, versionLabel].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(versionLabel.snp.top)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
}
