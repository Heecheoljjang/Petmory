//
//  PhotoViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/26.
//

import UIKit
import RxCocoa
import RxSwift

final class PhotoViewController: BaseViewController {
    
    private var mainView = PhotoView()
    
    let viewModel = PhotoViewModel()

    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }

    private func bind() {
//        viewModel.imageList.bind { [weak self] value in
//
//            self?.mainView.pageControl.numberOfPages = value.count
//        }
        
        let input = PhotoViewModel.Input(imageList: viewModel.imageList, collectionViewContentOffset: mainView.imageCollectionView.rx.contentOffset, tapDismiss: mainView.dismissButton.rx.tap)
        let output = viewModel.transform(input: input)
        
//        viewModel.imageList
//            .asDriver(onErrorJustReturn: [])
        output.numberOfPages
            .drive(onNext: { [weak self] value in
                print("numberofpages => \(value)")
                self?.mainView.pageControl.numberOfPages = value.count
            })
            .disposed(by: disposeBag)
        
//        viewModel.imageList
//            .asDriver(onErrorJustReturn: [])
        output.collectionViewItem
            .drive(mainView.imageCollectionView.rx.items(cellIdentifier: PhotoCollectionViewCell.identifier, cellType: PhotoCollectionViewCell.self)) { row, element, cell in
                
                cell.photoImageView.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
        
//        mainView.imageCollectionView.rx.contentOffset
//            .map { Double($0.x) }
//            .disposed(by: disposeBag)
        output.collectionViewXOffset
            .withUnretained(self)
            .bind(onNext: { vc, value in
//                let width = vc.mainView.imageCollectionView.frame.width
                guard let width = vc.mainView.window?.windowScene?.screen.bounds.width else { return }
                print(value, width)
                vc.mainView.pageControl.currentPage = vc.viewModel.pageControlPage(xOffset: value, width: width)
            })
            .disposed(by: disposeBag)
        
//        mainView.dismissButton.rx.tap
        output.tapDismiss
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.transition(vc, transitionStyle: .dismiss)
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
    
        mainView.imageCollectionView.delegate = self
//        mainView.dismissButton.addTarget(self, action: #selector(dismissPhotoView), for: .touchUpInside)
    }
    
    override func setUpController() {
        super.setUpController()
    }
    
    @objc private func dismissPhotoView() {
        transition(self, transitionStyle: .dismiss)
    }
    
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return viewModel.fetchImageListCount()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
//
//        let imageList = viewModel.imageList.value
//
//        cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
//
//        return cell
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.frame.size.width, height: mainView.frame.size.height)
    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let width = scrollView.frame.width
//        mainView.pageControl.currentPage = viewModel.pageControlPage(xOffset: scrollView.contentOffset.x, width: width)
//    }
}
