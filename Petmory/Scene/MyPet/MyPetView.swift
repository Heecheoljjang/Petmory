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
        view.register(AddPetTableViewCell.self, forCellReuseIdentifier: AddPetTableViewCell.identifier)
        view.register(MyPetTableViewCell.self, forCellReuseIdentifier: MyPetTableViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = NavigationTitleLabel.myPet
        label.textColor = .black
        label.textAlignment = .center
        
        return label
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
