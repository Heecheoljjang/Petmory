//
//  WritingViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import RealmSwift
//import IQKeyboardManagerSwift
import PhotosUI
import CropViewController

final class WritingViewController: BaseViewController {
    
    var mainView = WritingView()
    
    let repository = UserRepository()
    
    var petList: Results<UserPet>!
    
    var withList = List<String>()
    
//    var imageList = List<String>()
    
//    var imageArray: [UIImage] = [] {
//        didSet {
//            mainView.imageCollectionView.reloadData()
//        }
//    }
    var imageList = List<Data>() {
        didSet {
            print(imageList)
            mainView.imageCollectionView.reloadData()
            print("123")
        }
    }
    
    let placeholderText = "오늘 하루를 어떻게 보내셨나요?"
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList = repository.fetchPet()
        
        print(withList, imageList)
    }
    
    override func setUpController() {
        super.setUpController()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishWriting))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelWriting))
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = Date().dateToString(type: .simple)
        
        //MARK: 액션 추가
        mainView.pickButton.addTarget(self, action: #selector(presentPhotoPickerView), for: .touchUpInside)
        
        //MARK: 텍스트뷰
        mainView.contentTextView.text = placeholderText
        mainView.contentTextView.textColor = .placeholderColor
        
        
        mainView.titleTextField.inputAccessoryView = UIView()
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.petCollectionView.delegate = self
        mainView.petCollectionView.dataSource = self
        mainView.contentTextView.delegate = self
        //mainView.titleTextField.delegate = self
        
    }
    
    private func presentPHPickerViewController() {
        var configuartion = PHPickerConfiguration()
        configuartion.filter = .images
        
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        transition(picker, transitionStyle: .present)
    }
    
    //MARK: - @objc
    @objc private func finishWriting() {
        
        print(withList.count, imageList.count, mainView.titleTextField.text, mainView.contentTextView.text)
        withList.removeAll()
        mainView.petCollectionView.indexPathsForSelectedItems?.forEach {
            withList.append(petList[$0.item].petName)
        }
        let currentDate = Date()
        
        //MARK: 선택된 펫이 없는 경우, 제목이 없는 경우에 alert
        if withList.count == 0 && mainView.titleTextField.text! == "" {
            
            print("반려동물과 제목은 필수입니다!")
        } else if withList.count != 0 && mainView.titleTextField.text! == "" {
            print("제목을 작성해주세요")
        } else if withList.count == 0 && mainView.titleTextField.text! != "" {
            print("함께한 반려동물을 선택해주세요")
        } else {
            if mainView.contentTextView.textColor == .placeholderColor {
                let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date().dateToString(type: .simple), petList: withList, memoryContent: "", imageData: imageList, objectId: "\(currentDate)")
                repository.addMemory(item: task)
                transition(self, transitionStyle: .dismiss)
            } else {
                let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDate: Date().dateToString(type: .simple), petList: withList, memoryContent: mainView.contentTextView.text, imageData: imageList, objectId: "\(currentDate)")
                repository.addMemory(item: task)
                transition(self, transitionStyle: .dismiss)
            }
        }
    }
    
    @objc private func cancelWriting() {
        //alert띄워서 지울지말지 확인
        
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func presentPhotoPickerView() {
        print(imageList.count)
        if imageList.count <= 2 {
            presentPHPickerViewController()
        } else {
            print("No")
        }
    }
}

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
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteImage(_ :)), for: .touchUpInside)
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
            let width = mainView.frame.size.width - 40
            let cellSize = CGSize(width: width, height: width * 0.8)
            
            return cellSize
        }
    }
    @objc private func deleteImage(_ sender: UIButton) {
        //MARK: 지울건지 alert띄우기
        
        //테스트
        imageList.remove(at: sender.tag)
        mainView.imageCollectionView.reloadData()
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

        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        imageList.insert(imageData, at: 0)
        
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
