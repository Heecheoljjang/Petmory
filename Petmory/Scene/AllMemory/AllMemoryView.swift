//
//  AllMemoryView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import SnapKit

final class AllMemoryView: BaseView {

    let tableView: UITableView = {
        let view = UITableView()
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.register(AllMemoryTableViewCell.self, forCellReuseIdentifier: AllMemoryTableViewCell.identifier)
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(AllMemoryCollectionViewCell.self, forCellWithReuseIdentifier: AllMemoryCollectionViewCell.identifier)
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    let withLabel: UILabel = {
        let label = UILabel()
        label.text = "with"
        label.font = UIFont(name: CustomFont.bold, size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [tableView, collectionView, withLabel].forEach {
            self.addSubview($0)
        }
        backgroundColor = .systemBackground
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        withLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(withLabel.snp.trailing).offset(12)
            make.height.equalTo(52)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
