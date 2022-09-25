//
//  TodayListView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class TodayListView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(TodayListTableViewCell.self, forCellReuseIdentifier: TodayListTableViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        self.addSubview(tableView)
        
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
