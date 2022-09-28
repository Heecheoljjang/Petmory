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
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        layout.minimumInteritemSpacing = 8
//
//        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        view.register(MonthMemoryCollectionViewCell.self, forCellWithReuseIdentifier: MonthMemoryCollectionViewCell.identifier)
//        view.backgroundColor = .systemBackground
//        view.showsHorizontalScrollIndicator = false
//
//        return view
//    }()
    
//    let noMemoryLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.text = "작성한 기록이 없습니다!"
//        label.font = UIFont(name: CustomFont.medium, size: 12)
//        label.textColor = .lightGray
//
//        return label
//    }()
    
//    let withLabel: UILabel = {
//        let label = UILabel()
//        label.text = "with"
//        label.font = UIFont(name: CustomFont.bold, size: 15)
//
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
//        [tableView, withLabel, noMemoryLabel].forEach {
//            self.addSubview($0)
//        }
        addSubview(tableView)
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
//
//        noMemoryLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(200)
//        }
//
//        withLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self).offset(20)
//            make.top.equalTo(self.safeAreaLayoutGuide)
//            make.height.equalTo(52)
//        }
//
//        collectionView.snp.makeConstraints { make in
//            make.top.trailing.equalTo(self.safeAreaLayoutGuide)
//            make.leading.equalTo(withLabel.snp.trailing).offset(12)
//            make.height.equalTo(52)
//        }

        tableView.snp.makeConstraints { make in
//            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
