//
//  MonthMemoryViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/28.
//

import UIKit
//import RealmSwift
import RxCocoa
import RxSwift

final class MonthMemoryViewController: BaseViewController {
    
    private var mainView = MonthMemoryView()
    
    let viewModel = MonthMemoryViewModel()
    
    let disposeBag = DisposeBag()

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

    }
    
    private func bind() {

        viewModel.tasks
            .bind(to: mainView.tableView.rx.items(cellIdentifier: MonthMemoryTableViewCell.identifier, cellType: MonthMemoryTableViewCell.self)) { [weak self] (row, element, cell) in
                
                guard let task = self?.viewModel.fetchTaskData(),
                let equal = self?.viewModel.checkImageDataCount(task: task[row], compareType: .equal),
                let greater = self?.viewModel.checkImageDataCount(task: task[row], compareType: .greater) else { return }
                
                cell.memoryTitle.text = self?.viewModel.cellText(task: task[row], type: .title)
                cell.memoryContentLabel.text = self?.viewModel.cellText(task: task[row], type: .content)
                
                if equal {
                    cell.thumbnailImageView.isHidden = equal
                } else {
                    cell.thumbnailImageView.isHidden = equal
                    cell.thumbnailImageView.image = UIImage(data: task[row].imageData.first!)
                }
                cell.dateLabel.text = self?.viewModel.cellText(task: task[row], type: .date)
                if greater {
                    cell.multiSign.isHidden = !greater
                } else {
                    cell.multiSign.isHidden = !greater
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.tasks
            .map { $0.count == 0 }
            .bind(onNext: { [weak self] value in

                self?.mainView.tableView.isHidden = value
                self?.mainView.noMemoryLabel.isHidden = !value
                
                self?.mainView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { (vc, indexPath) in
                let memoryDetailViewController = MemoryDetailViewController()
                
                //MARK: - Behavior일때 이렇게 접근해서 사용해도괜찮은지
                let task = vc.viewModel.fetchTaskData()
                memoryDetailViewController.objectId = task[indexPath.row].objectId
                memoryDetailViewController.imageList = task[indexPath.row].imageData
                vc.transition(memoryDetailViewController, transitionStyle: .push)

            })
            .disposed(by: disposeBag)

    }
    
    override func setUpController() {
        
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
        mainView.titleLabel.text = viewModel.monthDate
    }

    //MARK: - @objc

    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

//MARK: - TableView
//extension MonthMemoryViewController: UITableViewDelegate, UITableViewDataSource {
    //저절로 되는듯
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.fetchTasksCount()
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthMemoryTableViewCell.identifier) as? MonthMemoryTableViewCell, let task = viewModel.tasks.value?[indexPath.row] else { return UITableViewCell() }
//
//        cell.memoryTitle.text = viewModel.cellText(task: task, type: .title)
//        cell.memoryContentLabel.text = viewModel.cellText(task: task, type: .content)
//
//        if viewModel.checkImageDataCount(task: task, compareType: .equal) {
//            cell.thumbnailImageView.isHidden = true
//        } else {
//            cell.thumbnailImageView.isHidden = false
//            cell.thumbnailImageView.image = UIImage(data: task.imageData.first!)
//        }
//        cell.dateLabel.text = viewModel.cellText(task: task, type: .date)
//        if viewModel.checkImageDataCount(task: task, compareType: .greater) {
//            cell.multiSign.isHidden = false
//        } else {
//            cell.multiSign.isHidden = true
//        }
//
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let memoryDetailViewController = MemoryDetailViewController()
//        guard let task = viewModel.tasks.value?[indexPath.row] else { return }
//
//        memoryDetailViewController.objectId = task.objectId
//        memoryDetailViewController.imageList = task.imageData
//        transition(memoryDetailViewController, transitionStyle: .push)
//    }
    
    
    //함
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 88
//    }
//}

