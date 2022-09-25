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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(settingTask(_ :)), name: NSNotification.Name.editWriting, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView(_ :)), name: NSNotification.Name.reloadCollectionView, object: nil)
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
                //imageList = memoryTask.imageData
                print(memoryTask.imageData.count)
               
            }
            if let imageList = imageList {
                if imageList.count == 0 {
                    mainView.imageCollectionView.isHidden = true
    //                mainView.imageCollectionView.reloadData()
                } else {
                    mainView.imageCollectionView.isHidden = false
    //                mainView.imageCollectionView.reloadData()
                }
                //mainView.imageCollectionView.reloadData()
            }
        }
        mainView.imageCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("뷰나왔ㅆ따")
        mainView.imageCollectionView.reloadData()
        print("뷰나온뒤에 리로드했다")
    }
    override func configure() {
        super.configure()
    }
    
    override func setUpController() {
        super.setUpController()
        
//        mainView.petCollectionView.delegate = self
//        mainView.petCollectionView.dataSource = self
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        //바버튼
        
        let menus = [
            UIAction(title: "수정", image: UIImage(systemName: "pencil")) { _ in
                self.presentEditView()
            },
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteMemory()
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
        isEditStatus = true
        transition(editViewController, transitionStyle: .presentNavigation)
        
    }
    @objc private func deleteMemory() {
       // guard let memoryTask = memoryTask else { return }
        
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
        
        print("노티피케이션 실행됨")
        memoryTask = repository.fetchWithObjectId(objectId: objectId).first
        
        if let memoryTask = memoryTask {
            
            mainView.titleLabel.text = memoryTask.memoryTitle
            mainView.dateLabel.text = memoryTask.memoryDateString
            mainView.contentTextView.text = memoryTask.memoryContent
           
        }
        if let imageList = imageList {
            if imageList.count == 0 {
                print("곧 히든")
                mainView.imageCollectionView.isHidden = true
                print("히든되었다")
//                mainView.imageCollectionView.reloadData()
            } else {
                print("곧 히든 풀림")
                mainView.imageCollectionView.isHidden = false
                print("히든 풀림 완료")
//                mainView.imageCollectionView.reloadData()
            }
            //mainView.imageCollectionView.reloadData()
        }
    }
    @objc private func reloadCollectionView(_ notification: NSNotification) {
        print("리로드 노티임")
        mainView.imageCollectionView.reloadData()
        print("리로드 노티임에서 리로드 끝")
    }
}

extension MemoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let memoryTask = memoryTask, let imageList = imageList else { return 0 }
        
//        if collectionView == mainView.petCollectionView {
//            return memoryTask.petList.count
//        } else {
//            return imageList.count
//        }
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == mainView.petCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailPetCollectionViewCell.identifier, for: indexPath) as? MemoryDetailPetCollectionViewCell else { return UICollectionViewCell() }
//
//            if let memoryTask = memoryTask {
//                cell.nameLabel.text = memoryTask.petList[indexPath.item]
//            }
//
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailImageCollectionViewCell.identifier, for: indexPath) as? MemoryDetailImageCollectionViewCell else { return UICollectionViewCell() }
//
//            guard let imageList = imageList else { return UICollectionViewCell() }
////
////            if let memoryTask = memoryTask {
////                cell.photoImageView.image = UIImage(data: memoryTask.imageData[indexPath.item])
////            }
//            cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
//            return cell
//        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailImageCollectionViewCell.identifier, for: indexPath) as? MemoryDetailImageCollectionViewCell else { return UICollectionViewCell() }
        
        guard let imageList = imageList else { return UICollectionViewCell() }

        cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let memoryTask = memoryTask else { return CGSize(width: 0, height: 0) }
//
//        if collectionView == mainView.petCollectionView {
//            if memoryTask.petList[indexPath.item].count > 1 {
//                let cellSize = CGSize(width: memoryTask.petList[indexPath.item].size(withAttributes: [.font : UIFont(name: CustomFont.medium, size: 13)!]).width + 32, height: 52)
//                return cellSize
//            } else {
//                let cellSize = CGSize(width: 52, height: 52)
//                return cellSize
//            }
//        } else {
//            let width = mainView.frame.size.width
//            let cellSize = CGSize(width: width, height: width * 0.8)
//
//            return cellSize
//        }
        let width = mainView.frame.size.width
        let cellSize = CGSize(width: width, height: width * 0.8)
        
        return cellSize
    }
    
}
