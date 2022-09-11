//
//  AllMemoryViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import Foundation
import UIKit
import RealmSwift

final class AllMemoryViewController: BaseViewController {
    
    var mainView = AllMemoryView()
    
    let repository = UserRepository()
    
    var tasks: Results<UserMemory>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    var petList: Results<UserPet>! {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    
    var filterPetName: String = "" {
        didSet {
            print(filterPetName)
            if filterPetName == "" {
                tasks = repository.fetchMemory()
                mainView.tableView.reloadData()
            } else {
                tasks = repository.fetchFiltered(name: filterPetName)
                mainView.tableView.reloadData()
            }
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
        
        tasks = repository.fetchMemory()
        petList = repository.fetchPet()
                
    }
    
    override func setUpController() {
        //네비게이션 바버튼
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissView))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(pushSearchView))
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = searchButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }

    //MARK: - @objc
    @objc private func dismissView() {
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func pushSearchView() {
        transition(SearchViewController(), transitionStyle: .push)
    }
}
