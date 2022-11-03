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
                
                guard let equal = self?.viewModel.checkImageDataCount(task: element, compareType: .equal),
                let greater = self?.viewModel.checkImageDataCount(task: element, compareType: .greater) else { return }
                
                cell.memoryTitle.text = self?.viewModel.cellText(task: element, type: .title)
                cell.memoryContentLabel.text = self?.viewModel.cellText(task: element, type: .content)
                
                if equal {
                    cell.thumbnailImageView.isHidden = equal
                } else {
                    cell.thumbnailImageView.isHidden = equal
                    cell.thumbnailImageView.image = UIImage(data: element.imageData.first!)
                }
                cell.dateLabel.text = self?.viewModel.cellText(task: element, type: .date)
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
                let imageList = vc.viewModel.fetchImageArray(imageList: task[indexPath.row].imageData)
                
                memoryDetailViewController.viewModel.objectId = task[indexPath.row].objectId
                memoryDetailViewController.viewModel.imageList.accept(imageList)
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

