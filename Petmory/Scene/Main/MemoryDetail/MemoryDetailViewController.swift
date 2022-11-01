//
//  MemoryDetailViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import RxSwift
import RxCocoa

final class MemoryDetailViewController: BaseViewController {
    
    private var mainView = MemoryDetailView()
    
    var viewModel = MemoryDetailViewModel()
    
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
        
        //편집 상태에서 돌아올때는 노티피케이션으로 memoryTasks를 주기 위해
        if viewModel.checkStatus() {
            
            viewModel.fetchWithObjectId() //바인드된 코드로 인해 텍스트 설정
        
            navigationItem.titleView = mainView.navigationTitleViewLabel

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.imageCollectionView.reloadData()
    }

    private func bind() {
//        viewModel.memoryTask.bind { [weak self] task in
//
//            guard let task = task else { return }
//
//            self?.mainView.titleLabel.attributedText = self?.setAttributedString(text: task.memoryTitle)
//
//            self?.mainView.contentTextView.text = task.memoryContent
//
//            self?.mainView.navigationTitleViewLabel.text = task.memoryDateString
//        }
//
//        viewModel.imageList.bind { [weak self] _ in
//
//            guard let checkCount = self?.viewModel.checkImageListCount() else { return }
//
//            self?.mainView.imageCollectionView.isHidden = checkCount
//
//            self?.mainView.imageCollectionView.reloadData()
//        }
        
        //MARK: - 하나의 시퀀스에서 하나의 코드만 실행되어야하는지, 아래처럼 한 번에 해도 괜찮은지
        viewModel.memoryTask
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] task in
            
            guard let task = task else { return }
            
            self?.mainView.titleLabel.attributedText = self?.setAttributedString(text: task.memoryTitle)
            
            self?.mainView.contentTextView.text = task.memoryContent
            
            self?.mainView.navigationTitleViewLabel.text = task.memoryDateString
            
            self?.viewModel.imageList.accept(task.imageData.map{ $0 })
        })
        .disposed(by: disposeBag)
        
        viewModel.imageList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
            guard let checkCount = self?.viewModel.checkImageListCount() else { return }
            
            self?.mainView.imageCollectionView.isHidden = checkCount
            
            self?.mainView.imageCollectionView.reloadData()
        })
        .disposed(by: disposeBag)
        
        viewModel.imageList
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.imageCollectionView.rx.items(cellIdentifier: MemoryDetailImageCollectionViewCell.identifier, cellType: MemoryDetailImageCollectionViewCell.self)) { (row, element, cell) in
                
                cell.photoImageView.image = UIImage(data: element)
                
            }
            .disposed(by: disposeBag)
        
        mainView.imageCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let photoViewController = PhotoViewController()
                guard let checkCount = self?.viewModel.checkImageListCount(),
                let imageList = self?.viewModel.imageList.value else { return }
                
                if !checkCount {
                    photoViewController.viewModel.imageList.value = imageList
                    self?.transition(photoViewController, transitionStyle: .present)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
    }
    
    override func setUpController() {
        super.setUpController()

        mainView.imageCollectionView.delegate = self
//        mainView.imageCollectionView.dataSource = self

        navigationController?.navigationBar.tintColor = .diaryColor

        //바버튼
        let menus = [
            UIAction(title: AlertText.edit, image: UIImage(systemName: ImageName.pencil)) { [weak self] _ in
                self?.presentEditView()
            },
            UIAction(title: AlertText.delete, image: UIImage(systemName: ImageName.delete), attributes: .destructive) { [weak self] _ in
                self?.deleteMemory()
            }
        ]

        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menus)

        let popButton = UIBarButtonItem(image: UIImage(systemName: ImageName.chevronLeft), style: .plain, target: self, action: #selector(popView))
        let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: ImageName.ellipsis), primaryAction: nil, menu: menu)
        navigationItem.leftBarButtonItem = popButton
        navigationItem.rightBarButtonItem = menuButton

        //네비게이션컨트롤러
        navigationItem.backButtonTitle = ""
    }
    
    private func presentEditView() {
        let editViewController = WritingViewController()
        editViewController.currentStatus = viewModel.setStatusEdit()
        editViewController.currentTask = viewModel.memoryTask.value
        
        guard let memoryTask = viewModel.memoryTask.value else { return }
        
        //memoryDate가 초기화되는 것을 막기위해 전달
        editViewController.memoryDate = memoryTask.memoryDate

        viewModel.appendImageData(list: editViewController.imageList)
        
        editViewController.settingDetailView = {
        
            self.viewModel.fetchWithObjectId()
            
            guard let memoryTask = self.viewModel.memoryTask.value else { return }
            
            let checkCount = self.viewModel.checkImageListCount()
            
            self.mainView.titleLabel.attributedText = self.setAttributedString(text: memoryTask.memoryTitle)
            self.mainView.contentTextView.text = memoryTask.memoryContent
            self.mainView.navigationTitleViewLabel.text = memoryTask.memoryDateString
            self.navigationItem.titleView = self.mainView.navigationTitleViewLabel
            
            self.mainView.imageCollectionView.isHidden = checkCount
            
            self.mainView.imageCollectionView.reloadData()
        }
        
        viewModel.isEditStatus = true
        
        transition(editViewController, transitionStyle: .presentNavigation)
        
    }
    
    private func setAttributedString(text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    @objc private func deleteMemory() {
        //MARK: 진짜 지울건지 확인하는 alert띄우기
        handlerAlert(title: AlertTitle.checkDelete, message: nil) { [weak self] _ in
            guard let memoryTask = self?.viewModel.memoryTask.value, let self = self else { return }
            self.viewModel.deleteMemory(item: memoryTask)
            self.transition(self, transitionStyle: .pop)
        }
    }
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
}

extension MemoryDetailViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return viewModel.fetchImageListCount()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailImageCollectionViewCell.identifier, for: indexPath) as? MemoryDetailImageCollectionViewCell, let imageList = viewModel.imageList.value else { return UICollectionViewCell() }
//
//        cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
//        return cell
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = mainView.frame.size.width
        let cellSize = CGSize(width: width, height: width * 0.8)
        
        return cellSize
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let photoViewController = PhotoViewController()
//        if !viewModel.checkImageListCount() {
//            photoViewController.viewModel.imageList.value = viewModel.imageList.value
//            transition(photoViewController, transitionStyle: .present)
//        }
//    }
}
