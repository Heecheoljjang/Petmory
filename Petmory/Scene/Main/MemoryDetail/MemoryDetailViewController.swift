//
//  MemoryDetailViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import RealmSwift

final class MemoryDetailViewController: BaseViewController {
    
    var mainView = MemoryDetailView()
    
    var memoryTask: UserMemory?
    
    var objectId: String = ""
    
    let repository = UserRepository()
    
    var imageList: List<Data>?
    
    var isEditStatus = false
    
    deinit {
        print("deinit")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //편집 상태에서 돌아올때는 노티피케이션으로 memoryTasks를 주기 위해
        if isEditStatus == false {
            memoryTask = repository.fetchWithObjectId(objectId: objectId).first
            
            if let memoryTask = memoryTask {
                
                mainView.titleLabel.text = memoryTask.memoryTitle
                mainView.dateLabel.text = memoryTask.memoryDateString
                mainView.contentTextView.text = memoryTask.memoryContent
               
            }
            if let imageList = imageList {
                if imageList.count == 0 {
                    mainView.imageCollectionView.isHidden = true
                } else {
                    mainView.imageCollectionView.isHidden = false
                }
            }
        }
        mainView.imageCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.imageCollectionView.reloadData()
    }

    override func configure() {
        super.configure()
    }
    
    override func setUpController() {
        super.setUpController()


        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self

        navigationController?.navigationBar.tintColor = .diaryColor

        //바버튼

        let menus = [
            UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.presentEditView()
            },
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteMemory()
            }
        ]

        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menus)

        let popButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(popView))
        let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: menu)
        navigationItem.leftBarButtonItem = popButton
        navigationItem.rightBarButtonItem = menuButton

        //네비게이션컨트롤러
        navigationItem.backButtonTitle = ""
    }
    
    private func presentEditView() {
        let editViewController = WritingViewController()
        editViewController.currentStatus = CurrentStatus.edit
        editViewController.currentTask = memoryTask
        
        //memoryDate가 초기화되는 것을 막기위해 전달
        if let memoryTask = memoryTask {
            editViewController.memoryDate = memoryTask.memoryDate
        }
        
        memoryTask?.imageData.forEach {
            editViewController.imageList.append($0)
        }
        editViewController.settingDetailView = {
            self.memoryTask = self.repository.fetchWithObjectId(objectId: self.objectId).first
            
            if let memoryTask = self.memoryTask {
                
                self.mainView.titleLabel.text = memoryTask.memoryTitle
                self.mainView.dateLabel.text = memoryTask.memoryDateString
                self.mainView.contentTextView.text = memoryTask.memoryContent
               
            }
            if let imageList = self.imageList {
                if imageList.count == 0 {
                    self.mainView.imageCollectionView.isHidden = true
                } else {
                    self.mainView.imageCollectionView.isHidden = false
                }
            }
            
            self.mainView.imageCollectionView.reloadData()
        }
        
        isEditStatus = true
        transition(editViewController, transitionStyle: .presentNavigation)
        
    }
    @objc private func deleteMemory() {
        //MARK: 진짜 지울건지 확인하는 alert띄우기
        handlerAlert(title: "삭제하시겠습니까?", message: nil) { _ in
            if let memoryTask = self.memoryTask {
                self.repository.deleteMemory(item: memoryTask)
                self.transition(self, transitionStyle: .pop)
            }
        }
    }
    @objc private func popView() {
        transition(self, transitionStyle: .pop)
    }
    
    @objc private func settingTask(_ notification: NSNotification) {
        
        memoryTask = repository.fetchWithObjectId(objectId: objectId).first
        
        if let memoryTask = memoryTask {
            
            mainView.titleLabel.text = memoryTask.memoryTitle
            mainView.dateLabel.text = memoryTask.memoryDateString
            mainView.contentTextView.text = memoryTask.memoryContent
           
        }
        if let imageList = imageList {
            if imageList.count == 0 {
                mainView.imageCollectionView.isHidden = true
            } else {
                mainView.imageCollectionView.isHidden = false
            }
        }
    }
    @objc private func reloadCollectionView(_ notification: NSNotification) {
        mainView.imageCollectionView.reloadData()
    }
}

extension MemoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imageList = imageList else { return 0 }

        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailImageCollectionViewCell.identifier, for: indexPath) as? MemoryDetailImageCollectionViewCell else { return UICollectionViewCell() }
        
        guard let imageList = imageList else { return UICollectionViewCell() }

        cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = mainView.frame.size.width
        let cellSize = CGSize(width: width, height: width * 0.8)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController()
        if imageList?.count != 0 {
            photoViewController.imageList = imageList
            transition(photoViewController, transitionStyle: .present)
        }
    }
}
