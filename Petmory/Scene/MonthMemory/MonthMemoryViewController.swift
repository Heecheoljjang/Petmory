//
//  MonthMemoryViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/28.
//

import UIKit
import RealmSwift

final class MonthMemoryViewController: BaseViewController {
    
    private var mainView = MonthMemoryView()
    
    let viewModel = MonthMemoryViewModel()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchDateFiltered()
        
        if viewModel.checkTasksCount() {
            mainView.tableView.isHidden = true
            mainView.noMemoryLabel.isHidden = false
        } else {
            mainView.tableView.isHidden = false
            mainView.noMemoryLabel.isHidden = true
        }
    }
    
    private func bind() {
        viewModel.tasks.bind { [weak self] _ in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.monthDate.bind { [weak self] value in
            self?.viewModel.fetchDateFiltered()
            self?.mainView.titleLabel.text = value
        }
    }
    
    override func setUpController() {
        //네비게이션 바버튼
        let popButton = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronLeft), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
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

    }

    //MARK: - @objc

    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

//MARK: - TableView
extension MonthMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchTasksCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthMemoryTableViewCell.identifier) as? MonthMemoryTableViewCell, let task = viewModel.tasks.value?[indexPath.row] else { return UITableViewCell() }
    
        cell.memoryTitle.text = viewModel.cellText(task: task, type: .title)
        cell.memoryContentLabel.text = viewModel.cellText(task: task, type: .content)
        
        if viewModel.checkImageDataCount(task: task, compareType: .equal) {
            cell.thumbnailImageView.isHidden = true
        } else {
            cell.thumbnailImageView.isHidden = false
            cell.thumbnailImageView.image = UIImage(data: task.imageData.first!)
        }
        cell.dateLabel.text = viewModel.cellText(task: task, type: .date)
        if viewModel.checkImageDataCount(task: task, compareType: .greater) {
            cell.multiSign.isHidden = false
        } else {
            cell.multiSign.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoryDetailViewController = MemoryDetailViewController()
        guard let task = viewModel.tasks.value?[indexPath.row] else { return }
                
        memoryDetailViewController.objectId = task.objectId
        memoryDetailViewController.imageList = task.imageData
        transition(memoryDetailViewController, transitionStyle: .push)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

