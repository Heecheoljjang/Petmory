//
//  MonthMemoryView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/28.
//

import UIKit
import SnapKit

final class MonthMemoryView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MonthMemoryTableViewCell.self, forCellReuseIdentifier: MonthMemoryTableViewCell.identifier)
        view.separatorStyle = .singleLine
        view.separatorColor = .systemGray5
        view.separatorInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        view.sectionHeaderTopPadding = 0
        view.tableHeaderView = UIView()
        return view
    }()
    
    let noMemoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "작성한 기록이 없습니다!"
        label.font = UIFont(name: CustomFont.medium, size: 12)
        label.textColor = .lightGray
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()

        [tableView, noMemoryLabel].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        noMemoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
    }
}
