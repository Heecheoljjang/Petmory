//
//  AllMemoryViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/09.
//

import UIKit
import RealmSwift
import RxDataSources
import RxSwift
import RxCocoa

final class AllMemoryViewController: BaseViewController {
    
    private var mainView = AllMemoryView()
    
    private let viewModel = AllMemoryViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllMemory() //tasks 값 바뀜
        viewModel.fetchPetList() //petList 값 바뀜
    }
    
    private func bind() {
        
        let input = AllMemoryViewModel.Input(petCount: viewModel.petList) //MARK: 흐름을 보기 위해 일부러 따로 설정해뒀는데 이렇게 해도되는지
        let output = viewModel.transform(input: input)
        
//        viewModel.tasks
//            .asDriver(onErrorJustReturn: [])
        output.tasks
            .drive(onNext: { [weak self] value in
                //MARK: dateList세팅, tasksCount세팅
                self?.viewModel.fetchDateList(tasks: value)
                self?.viewModel.fetchTasksCount(tasks: value)
            })
            .disposed(by: disposeBag)
        
//        viewModel.tasksCount
//            .asDriver(onErrorJustReturn: false)
        output.tasksCount
            .drive(onNext: { [weak self] value in
                self?.mainView.tableView.isHidden = value
                self?.mainView.noMemoryLabel.isHidden = !value
            })
            .disposed(by: disposeBag)
        
//        viewModel.petList
//            .asDriver(onErrorJustReturn: [])
        output.petList
            .drive(mainView.collectionView.rx.items(cellIdentifier: AllMemoryCollectionViewCell.identifier, cellType: AllMemoryCollectionViewCell.self)) { (row, element, cell) in
                cell.nameLabel.text = element.petName
            }
            .disposed(by: disposeBag)
        
//        viewModel.petList
//            .map {$0.count > 1}
//            .asDriver(onErrorJustReturn: false)
        output.checkPetCount
            .drive(onNext: { [weak self] value in
                self?.viewModel.petListCount.accept(true)
            })
            .disposed(by: disposeBag)
        
//        viewModel.dateList
//            .asDriver(onErrorJustReturn: [])
        output.dateList
            .drive(onNext: { [weak self] value in
                self?.viewModel.sectionCount.accept(value.count)
                self?.mainView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
//        viewModel.filterPetName
//            .asDriver(onErrorJustReturn: "")
        output.filterPetName
            .drive(onNext: { [weak self] value in
                guard let self = self else { return }
                self.viewModel.checkFilterPetName(name: value) ? self.viewModel.fetchAllMemory() : self.viewModel.fetchFiltered(name: value)
            })
            .disposed(by: disposeBag)
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
//        mainView.collectionView.dataSource = self
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
        return viewModel.sectionCount.value
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllMemoryTableViewCell.identifier, for: indexPath) as? AllMemoryTableViewCell,
              let tempTask = viewModel.tableViewCellTask(section: indexPath.section, row: indexPath.row) else { return UITableViewCell() }
        
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

        memoryDetailViewController.viewModel.objectId = tempTask.objectId
        memoryDetailViewController.viewModel.imageList.accept(tempTask.imageData.map { $0 })
        transition(memoryDetailViewController, transitionStyle: .push)
    }
}

//MARK: - CollectionView

extension AllMemoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //MARK: didSelect로 되는지 다시 확인
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return true }

        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel.setFilterPetName(name: "")
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            viewModel.setFilterPetName(name: viewModel.petList.value[indexPath.item].petName)
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if viewModel.petListCount.value {
            let cellSize = CGSize(width: viewModel.fetchPetName(item: indexPath.item).size(withAttributes: [.font : UIFont(name: CustomFont.medium, size: 13)!]).width + 32, height: 52)
            return cellSize
        } else {
            let cellSize = CGSize(width: 52, height: 52)
            return cellSize
        }
    }
}
