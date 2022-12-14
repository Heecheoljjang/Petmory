//
//  BackupRestoreView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/27.
//

import UIKit
import SnapKit

final class BackupResotreView: BaseView {
    let messageTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: CustomFont.medium, size: 11)
        view.text = BackupLabel.backupMessage
        view.textColor = .lightGray
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .insetGrouped)
        view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.register(BackupRestoreTableViewCell.self, forCellReuseIdentifier: BackupRestoreTableViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.separatorStyle = .singleLine
        view.backgroundColor = .white
        view.sectionHeaderTopPadding = 0
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        view .tableHeaderView = UIView(frame: frame)
    
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    let backupButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .darkGray
        configuration.baseBackgroundColor = .veryLightGray
        
        var attributedTitle = AttributedString.init(ButtonTitle.makeBackupFile)
        attributedTitle.font = UIFont(name: CustomFont.medium, size: 14)
        configuration.attributedTitle = attributedTitle
        
        button.configuration = configuration
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    let restoreButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .darkGray
        configuration.baseBackgroundColor = .veryLightGray
        
        var attributedTitle = AttributedString.init(ButtonTitle.restore)
        attributedTitle.font = UIFont(name: CustomFont.medium, size: 14)
        configuration.attributedTitle = attributedTitle
        
        button.configuration = configuration
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    let backupFileLabel: UILabel = {
        let label = UILabel()
        label.text = LabelText.backupFile
        label.textColor = .lightGray
        label.font = UIFont(name: CustomFont.medium, size: 10)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = NavigationTitleLabel.backupRestore
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [backupButton, restoreButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [messageTextView, tableView, stackView, backupFileLabel].forEach {
            addSubview($0)
        }
        
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        backupFileLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(16)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backupFileLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
