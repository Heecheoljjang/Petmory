//
//  PhotoViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/26.
//

import UIKit
import RealmSwift

final class PhotoViewController: BaseViewController {
    
    var mainView = PhotoView()
    
    var imageList: List<Data>? {
        didSet {
            if let imageList = imageList {
                mainView.pageControl.numberOfPages = imageList.count
            }
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func configure() {
        super.configure()
    
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        
        mainView.dismissButton.addTarget(self, action: #selector(dismissPhotoView), for: .touchUpInside)
        
    }
    
    override func setUpController() {
        super.setUpController()
    }
    
    @objc private func dismissPhotoView() {
        transition(self, transitionStyle: .dismiss)
    }
    
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let imageList = imageList else { return 0 }
        
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
    
        if let imageList = imageList {
            cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.frame.size.width, height: mainView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        mainView.pageControl.currentPage = Int(scrollView.contentOffset.x / width)
    }
}
