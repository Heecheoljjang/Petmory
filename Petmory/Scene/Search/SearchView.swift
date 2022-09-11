//
//  SearchView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import SnapKit

final class SearchView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: CustomFont.medium, size: 15)
        label.textAlignment = .center
        
        return label
    }()
    
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
        
        [label, tableView].forEach {
            self.addSubview($0)
        }
        backgroundColor = .stringColor
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
