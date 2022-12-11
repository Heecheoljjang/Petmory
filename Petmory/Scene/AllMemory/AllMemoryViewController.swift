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
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllMemory()
        viewModel.fetchPetList()
    }
    
    private func bind() {
        
        let input = AllMemoryViewModel.Input(petCount: viewModel.petList, tapDismissButton: mainView.dismissButton.rx.tap, tapSearchButton: mainView.searchButton.rx.tap, tapBackButton: mainView.backButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.tapDismissButton
            .bind(onNext: { [weak self] _ in
                self?.dismissView()
            })
            .disposed(by: disposeBag)
        
        output.tapSearchButton
            .bind(onNext: { [weak self] _ in
                self?.pushSearchView()
            })
            .disposed(by: disposeBag)
        
        output.tapBackButton
            .bind(onNext: { [weak self] _ in
                self?.popView()
            })
            .disposed(by: disposeBag)
        
        output.fetchDateListAndTaskCount

        output.tasksCount
            .drive(onNext: { [weak self] value in
                self?.mainView.tableView.isHidden = value
                self?.mainView.noMemoryLabel.isHidden = !value
            })
            .disposed(by: disposeBag)

        output.petList
            .drive(mainView.collectionView.rx.items(cellIdentifier: AllMemoryCollectionViewCell.identifier, cellType: AllMemoryCollectionViewCell.self)) { (row, element, cell) in
                cell.nameLabel.text = element.petName
            }
            .disposed(by: disposeBag)

        output.checkPetCount

        output.dateList
            .drive(onNext: { [weak self] value in
                self?.viewModel.sectionCount.accept(value.count)
                self?.mainView.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.filterPetName
    }
    
    override func setUpController() {
        //네비게이션 바버튼
        
        navigationItem.leftBarButtonItem = mainView.dismissButton
        navigationItem.rightBarButtonItem = mainView.searchButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.backButtonTitle = ""
        navigationItem.backBarButtonItem = mainView.backButton
        
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
        mainView.collectionView.delegate = self
    }

    private func dismissView() {
        transition(self, transitionStyle: .dismiss)
    }
    private func pushSearchView() {
        transition(SearchViewController(), transitionStyle: .push)
    }
    private func popView() {
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
