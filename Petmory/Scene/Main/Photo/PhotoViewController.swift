//
//  PhotoViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/26.
//

import UIKit
import RealmSwift

final class PhotoViewController: BaseViewController {
    
    private var mainView = PhotoView()
    
    let viewModel = PhotoViewModel()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }

    private func bind() {
        viewModel.imageList.bind { [weak self] value in
                        
            self?.mainView.pageControl.numberOfPages = value.count
        }
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
        
        return viewModel.fetchImageListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }

        let imageList = viewModel.imageList.value
        
        cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.frame.size.width, height: mainView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        mainView.pageControl.currentPage = viewModel.pageControlPage(xOffset: scrollView.contentOffset.x, width: width)
    }
}
