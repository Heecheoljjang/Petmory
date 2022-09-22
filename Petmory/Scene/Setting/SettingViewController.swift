//
//  SettingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/20.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    var mainView = SettingView()
    
    let settingList = [SettingList.backup, SettingList.message, SettingList.review, SettingList.shareApp]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpController() {
        super.setUpController()
        
        navigationItem.title = "설정"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        //바버튼
        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
    }
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    //MARK: - @objc
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = settingList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
