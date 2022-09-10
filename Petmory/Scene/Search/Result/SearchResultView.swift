//
//  SearchResultView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import SnapKit

final class SearchResultView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        view.backgroundColor = .stringColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override func configure() {
        super.configure()
        
        self.addSubview(tableView)
        backgroundColor = .stringColor
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
