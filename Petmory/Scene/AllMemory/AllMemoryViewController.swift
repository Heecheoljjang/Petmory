//
//  AllMemoryViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import UIKit
import RealmSwift

final class AllMemoryViewController: BaseViewController {
    
    private var mainView = AllMemoryView()
    
    private let viewModel = AllMemoryViewModel()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllMemory()
        viewModel.fetchPetList()
        
        if viewModel.checkTasksCount() {
            mainView.tableView.isHidden = true
            mainView.noMemoryLabel.isHidden = false
        } else {
            mainView.tableView.isHidden = false
            mainView.noMemoryLabel.isHidden = true
        }
        
    }
    
    private func bind() {
        
        viewModel.tasks.bind { [weak self] value in
            
            guard let value = value else { return }
            self?.viewModel.dateList.value = Set(value.map{ $0.memoryDate.dateToString(type: .yearMonth) }).sorted(by: >)
        }
        
        viewModel.petList.bind { [weak self] _ in
            self?.mainView.collectionView.reloadData()
        }
        
        viewModel.filterPetName.bind { [weak self] value in
            if value == "" {
                self?.viewModel.fetchAllMemory()
            } else {
                self?.viewModel.fetchFiltered(name: value)
            }
        }
        
        viewModel.dateList.bind { [weak self] _ in
            self?.mainView.tableView.reloadData()
        }
    }
    
    override func setUpController() {
        //네비게이션 바버튼
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronDown), style: .plain, target: self, action: #selector(dismissView))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: ImageName.magnifyingglass), style: .plain, target: self, action: #selector(pushSearchView))
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = searchButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronLeft), style: .plain, target: self, action: #selector(popView))
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.titleView = mainView.titleLabel
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dateList.value.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: mainView.frame.size.width - 40, height: 32))
        label.font = UIFont(name: CustomFont.bold, size: 18)
        label.text = viewModel.dateList.value[section]
        label.textColor = .black
        
        let view = UIView()
        view.backgroundColor = .veryLightGray
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllMemoryTableViewCell.identifier, for: indexPath) as? AllMemoryTableViewCell, let tempTask = viewModel.tableViewCellTask(section: indexPath.section, row: indexPath.row) else { return UITableViewCell() }
        
        cell.memoryTitle.text = viewModel.cellText(task: tempTask, type: .title)
        cell.memoryContentLabel.text = viewModel.cellText(task: tempTask, type: .content)
        
        if viewModel.checkImageDataCount(task: tempTask, compareType: .equal) {
            cell.thumbnailImageView.isHidden = true
        } else {
            cell.thumbnailImageView.isHidden = false
            cell.thumbnailImageView.image = UIImage(data: tempTask.imageData.first!)
        }
        
        cell.dateLabel.text = viewModel.cellText(task: tempTask, type: .date)
        
        if viewModel.checkImageDataCount(task: tempTask, compareType: .greater) {
            cell.multiSign.isHidden = false
        } else {
            cell.multiSign.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let tempTask = viewModel.tableViewCellTask(section: indexPath.section, row: indexPath.row) else { return }
        
        let memoryDetailViewController = MemoryDetailViewController()

        memoryDetailViewController.objectId = tempTask.objectId
        memoryDetailViewController.imageList = tempTask.imageData
        transition(memoryDetailViewController, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

//MARK: - CollectionView

extension AllMemoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllMemoryCollectionViewCell.identifier, for: indexPath) as? AllMemoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.nameLabel.text = viewModel.petList.value?[indexPath.item].petName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return true }

        if cell.isSelected == true {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel.setFilterPetName(name: "")
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            viewModel.setFilterPetName(name: viewModel.petList.value?[indexPath.item].petName ?? "")
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if viewModel.checkPetListCount(item: indexPath.item) {
            
            let cellSize = CGSize(width: viewModel.fetchPetName(item: indexPath.item).size(withAttributes: [.font : UIFont(name: CustomFont.medium, size: 13)!]).width + 32, height: 52)
            
            return cellSize
        } else {
            let cellSize = CGSize(width: 52, height: 52)
            return cellSize
        }
    }
}
