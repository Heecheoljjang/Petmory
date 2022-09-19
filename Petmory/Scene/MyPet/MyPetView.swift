//
//  MyPetView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//
import UIKit
import SnapKit

final class MyPetView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(MyPetTableViewCell.self, forCellReuseIdentifier: MyPetTableViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    let noPetLabel: UILabel = {
        let label = UILabel()
        label.text = "반려동물을 등록해주세요 :)"
        label.textAlignment = .center
        label.font = UIFont(name: CustomFont.medium, size: 12)
        label.textColor = .lightGray
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
            
        [tableView, noPetLabel].forEach {
            self.addSubview($0)
        }
        
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noPetLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
    }
}
