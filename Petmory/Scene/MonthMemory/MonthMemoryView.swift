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
        view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.register(MonthMemoryTableViewCell.self, forCellReuseIdentifier: MonthMemoryTableViewCell.identifier)
        view.separatorStyle = .none
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
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        noMemoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
    }
}
