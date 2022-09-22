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
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        self.addSubview(tableView)
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
