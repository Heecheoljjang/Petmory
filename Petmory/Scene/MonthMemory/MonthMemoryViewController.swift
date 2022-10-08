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
    
    private let repository = UserRepository()
    
    private var tasks: Results<UserMemory>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    var monthDate: String = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = repository.fetchDateFiltered(dateString: monthDate)
        
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
        let popButton = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronLeft), style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = popButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    
        mainView.titleLabel.text = monthDate
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
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthMemoryTableViewCell.identifier) as? MonthMemoryTableViewCell else { return UITableViewCell() }

        cell.memoryTitle.text = tasks[indexPath.row].memoryTitle
        cell.memoryContentLabel.text = tasks[indexPath.row].memoryContent
        
        if tasks[indexPath.row].imageData.count == 0 {
            cell.thumbnailImageView.isHidden = true
        } else {
            cell.thumbnailImageView.isHidden = false
            cell.thumbnailImageView.image = UIImage(data: tasks[indexPath.row].imageData.first!)
        }
        cell.dateLabel.text = tasks[indexPath.row].memoryDate.dateToString(type: .monthDay)
        if tasks[indexPath.row].imageData.count > 1 {
            cell.multiSign.isHidden = false
        } else {
            cell.multiSign.isHidden = true
        }
        
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

