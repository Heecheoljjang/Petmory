//
//  TodayListViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift

final class TodayListViewController: BaseViewController {
    
    var mainView = TodayListView()
    
    let repository = UserRepository()
    
    var tasks: Results<UserMemory>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = repository.fetchTodayMemory()
        
    }
        
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension TodayListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayListTableViewCell.identifier) as? TodayListTableViewCell else { return UITableViewCell() }
        
        cell.mainImageView.image = tasks[indexPath.row].imageData.count == 0 ? UIImage(systemName: "heart.fill") : UIImage(data: tasks[indexPath.row].imageData.first!)
        cell.titleLabel.text = tasks[indexPath.row].memoryTitle
        cell.contentLabel.text = tasks[indexPath.row].memoryContent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoryDetailViewController = MemoryDetailViewController()
        memoryDetailViewController.objectId = tasks[indexPath.row].objectId
        memoryDetailViewController.imageList = tasks[indexPath.row].imageData
        transition(memoryDetailViewController, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
