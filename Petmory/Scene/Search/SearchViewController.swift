//
//  SearchViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import RealmSwift

final class SearchViewController: BaseViewController {
    
    var mainView = SearchView()
        
    let repository = UserRepository()
    
    var tasks: Results<UserMemory>! {
        didSet {
            if tasks.count == 0 {
                mainView.tableView.isHidden = true
            } else {
                mainView.tableView.isHidden = false
            }
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = repository.fetchSearched(keyword: "")
    }
 
    override func setUpController() {
        super.setUpController()
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "제목, 내용 검색"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(cancelSearch))
        navigationItem.leftBarButtonItem = popButton

    }
    
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    //MARK: - @objc
    @objc private func cancelSearch() {
        transition(self, transitionStyle: .pop)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let tempTask = tasks[indexPath.row]
        
        cell.memoryTitle.text = tempTask.memoryTitle
        cell.memoryDateLabel.text = tempTask.memoryDateString
        cell.thumbnailImageView.image = tempTask.imageData.count == 0 ? nil : UIImage(data: tempTask.imageData.first!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoryDetailViewController = MemoryDetailViewController()
        memoryDetailViewController.objectId = tasks[indexPath.row].objectId
        memoryDetailViewController.imageList = tasks[indexPath.row].imageData
        transition(memoryDetailViewController, transitionStyle: .push)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else { return }
        tasks = repository.fetchSearched(keyword: text)
        
        mainView.tableView.reloadData()
        
    }
}
