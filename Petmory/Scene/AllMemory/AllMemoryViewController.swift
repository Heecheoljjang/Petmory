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
            if filterPetName == "" {
                tasks = repository.fetchAllMemory()
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
        
        tasks = repository.fetchAllMemory()
        petList = repository.fetchPet()
        
        if tasks.count == 0 {
            mainView.tableView.isHidden = true
            mainView.noMemoryLabel.isHidden = false
        } else {
            mainView.tableView.isHidden = false
            mainView.noMemoryLabel.isHidden = true
        }
        
    }
    
    override func setUpController() {
        //네비게이션 바버튼
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(dismissView))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(pushSearchView))
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = searchButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popView))
        //navigationItem.hidesBackButton = true
        
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
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

//MARK: - TableView
extension AllMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllMemoryTableViewCell.identifier, for: indexPath) as? AllMemoryTableViewCell else { return UITableViewCell() }
        
        cell.memoryTitle.text = tasks[indexPath.row].memoryTitle
        cell.memoryDate.text = tasks[indexPath.row].memoryDateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoryDetailViewController = MemoryDetailViewController()
        memoryDetailViewController.objectId = tasks[indexPath.row].objectId
        memoryDetailViewController.imageList = tasks[indexPath.row].imageData
        transition(memoryDetailViewController, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

//MARK: - CollectionView

extension AllMemoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllMemoryCollectionViewCell.identifier, for: indexPath) as? AllMemoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.nameLabel.text = petList[indexPath.item].petName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return true }

        if cell.isSelected == true {
            collectionView.deselectItem(at: indexPath, animated: true)
            filterPetName = ""
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            filterPetName = petList[indexPath.item].petName
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if petList[indexPath.item].petName.count > 1 {
            let cellSize = CGSize(width: petList[indexPath.item].petName.size(withAttributes: [.font : UIFont(name: CustomFont.medium, size: 13)!]).width + 32, height: 52)
            return cellSize
        } else {
            let cellSize = CGSize(width: 52, height: 52)
            return cellSize
        }
    }
}
