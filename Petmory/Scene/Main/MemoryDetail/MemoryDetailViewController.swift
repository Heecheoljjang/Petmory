//
//  MemoryDetailViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit

final class MemoryDetailViewController: BaseViewController {
    
    var mainView = MemoryDetailView()
    
    var memoryTask: UserMemory?
    
    var objectId: String = ""
    
    let repository = UserRepository()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoryTask = repository.fetchWithObjectId(objectId: objectId).first
        
        if let memoryTask = memoryTask {
            
            mainView.titleLabel.text = memoryTask.memoryTitle
            mainView.dateLabel.text = memoryTask.memoryDateString
            mainView.contentTextView.text = memoryTask.memoryContent
            if memoryTask.imageData.count == 0 {
                mainView.imageCollectionView.isHidden = true
            } else {
                mainView.imageCollectionView.isHidden = false
                mainView.imageCollectionView.reloadData()
            }
            print(memoryTask.imageData)
        }
        
    }
    
    override func configure() {
        super.configure()
    }
    
    override func setUpController() {
        super.setUpController()
        
        mainView.petCollectionView.delegate = self
        mainView.petCollectionView.dataSource = self
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        //바버튼
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(presentEditView))
        let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteMemory))
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func presentEditView() {
        let editViewController = WritingViewController()
        editViewController.currentStatus = CurrentStatus.edit
        editViewController.currentTask = memoryTask
        
        transition(editViewController, transitionStyle: .presentNavigation)
        
    }
    @objc private func deleteMemory() {
        guard let memoryTask = memoryTask else { return }
        
        //MARK: 진짜 지울건지 확인하는 alert띄우기
        
        
        
        repository.deleteMemory(item: memoryTask)
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func dismissView() {
        transition(self, transitionStyle: .dismiss)
    }
}

extension MemoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let memoryTask = memoryTask else { return 0 }
        
        if collectionView == mainView.petCollectionView {
            return memoryTask.petList.count
        } else {
            return memoryTask.imageData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.petCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailPetCollectionViewCell.identifier, for: indexPath) as? MemoryDetailPetCollectionViewCell else { return UICollectionViewCell() }
            
            if let memoryTask = memoryTask {
                cell.nameLabel.text = memoryTask.petList[indexPath.item]
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryDetailImageCollectionViewCell.identifier, for: indexPath) as? MemoryDetailImageCollectionViewCell else { return UICollectionViewCell() }
            
            if let memoryTask = memoryTask {
                cell.photoImageView.image = UIImage(data: memoryTask.imageData[indexPath.item])
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let memoryTask = memoryTask else { return CGSize(width: 0, height: 0) }
        
        if collectionView == mainView.petCollectionView {
            if memoryTask.petList[indexPath.item].count > 1 {
                let cellSize = CGSize(width: memoryTask.petList[indexPath.item].size(withAttributes: [.font : UIFont(name: CustomFont.medium, size: 13)!]).width + 32, height: 52)
                return cellSize
            } else {
                let cellSize = CGSize(width: 52, height: 52)
                return cellSize
            }
        } else {
            let width = mainView.frame.size.width
            let cellSize = CGSize(width: width, height: width * 0.8)
            
            return cellSize
        }
    }
    
}
