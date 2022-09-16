//
//  WritingViewController+Extension.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/12.
//

import Foundation
import UIKit
import PhotosUI
import CropViewController

//MARK: - CollectionView
extension WritingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.petCollectionView {
            return petList.count
        } else {
            return imageList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mainView.petCollectionView {
            
        } else {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.petCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingPetCollectionViewCell.identifier, for: indexPath) as? WritingPetCollectionViewCell else { return UICollectionViewCell() }
            cell.nameLabel.text = petList[indexPath.item].petName
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingImageCollectionViewCell.identifier, for: indexPath) as? WritingImageCollectionViewCell else { return UICollectionViewCell() }
            cell.photoImageView.image = UIImage(data: imageList[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainView.petCollectionView {
            if petList[indexPath.item].petName.count > 1 {
                let cellSize = CGSize(width: petList[indexPath.item].petName.size(withAttributes: [.font : UIFont(name: CustomFont.medium, size: 13)!]).width + 32, height: 52)
                return cellSize
            } else {
                let cellSize = CGSize(width: 52, height: 52)
                return cellSize
            }
        } else {
            let width = UIScreen.main.bounds.size.width - 40
            let cellSize = CGSize(width: width, height: width * 0.8)
            
            return cellSize
        }
    }
}

//MARK: - PHPickerViewController

extension WritingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        transition(self, transitionStyle: .dismiss)
        
        //편집 띄우기
        let itemProvider = results.first?.itemProvider
        
        itemProvider?.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                let cropViewController = CropViewController(image: selectedImage)
                cropViewController.delegate = self
                cropViewController.doneButtonColor = .stringColor
                cropViewController.cancelButtonColor = .stringColor
                cropViewController.doneButtonTitle = "완료"
                cropViewController.cancelButtonTitle = "취소"
                self.transition(cropViewController, transitionStyle: .present)

            }
        }
    }
}

//MARK: - CropViewController
extension WritingViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
//        if let compressedImage = UIImage(data: imageData) {
//            imageArray.append(compressedImage)
//        }
//        transition(self, transitionStyle: .dismiss)
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        imageList.append(imageData)
        print(imageList)
        mainView.imageCollectionView.reloadData()
        transition(self, transitionStyle: .dismiss)
    }
}

//MARK: - TextView
extension WritingViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        let writingContentVC = WritingContentViewController()
        
        writingContentVC.sendContentText = { text in
            if text == "" {
                self.mainView.contentTextView.text = "오늘 하루를 어떻게 보내셨나요?"
                self.mainView.contentTextView.textColor = .placeholderColor
            } else {
                self.mainView.contentTextView.text = text
                self.mainView.contentTextView.textColor = .black
            }
        }
        if mainView.contentTextView.textColor == .placeholderColor {
            writingContentVC.mainView.textView.text = ""
        } else {
            writingContentVC.mainView.textView.text = mainView.contentTextView.text
        }
        
        transition(writingContentVC, transitionStyle: .presentNavigationModally)
        return false
    }
}
