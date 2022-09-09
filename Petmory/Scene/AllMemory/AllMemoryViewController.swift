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
    
    var tasks: Results<UserMemory>!
    var petList: Results<UserPet>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //transition(self, transitionStyle: .push)
    }
}
