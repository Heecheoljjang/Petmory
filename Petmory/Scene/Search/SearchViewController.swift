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
    
    let resultVC = SearchResultViewController()
    
    let repository = UserRepository()
    
    var tasks: Results<UserMemory>! {
        didSet {
            resultVC.mainView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpController() {
        super.setUpController()
        
        let searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .diaryColor
        searchController.searchResultsUpdater = self
        resultVC.mainView.tableView.delegate = self
        resultVC.mainView.tableView.dataSource = self
        navigationItem.searchController = searchController
    }
}
