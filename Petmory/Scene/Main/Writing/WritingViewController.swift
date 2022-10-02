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

    var currentStatus = CurrentStatus.new
    
    var imageList = List<Data>() {
        didSet {
            mainView.imageCollectionView.reloadData()
        }
    }
    
    let placeholderText = "어떤 하루를 보내셨나요?"
    
    var currentTask: UserMemory?
    
    var memoryDate = Date() {
        didSet {
            mainView.titleViewDatePicker.date = memoryDate
            
            var attributedTitle = AttributedString(memoryDate.dateToString(type: .simple))
            attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
            mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
            navigationItem.titleView = mainView.titleViewButton
        }
    }
    
    var tempDate = Date()
    
    //사진 고를때 잠깐 보이는 시점인지 확인하는 프로퍼티
    var isSelectingPhoto = false
    
    var settingDetailView: (() -> ())?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList = repository.fetchPet()
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if currentStatus == CurrentStatus.edit {
            if let currentTask = currentTask {
                mainView.titleTextField.text = currentTask.memoryTitle
                mainView.contentTextView.text = currentTask.memoryContent
            }
            if mainView.contentTextView.text != "" {
                mainView.contentTextView.textColor = .black
            } else {
                mainView.contentTextView.text = placeholderText
                mainView.contentTextView.textColor = .placeholderColor
            }
        }
        
        mainView.imageCollectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        settingDetailView?()
    }
    
    override func setUpController() {
        super.setUpController()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishWriting))
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelWriting))
        
        navigationController?.navigationBar.tintColor = .diaryColor
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance

        //MARK: 텍스트뷰
        mainView.contentTextView.text = placeholderText
        mainView.contentTextView.textColor = .placeholderColor
                
        //MARK: 네비게이션 타이틀 뷰
        mainView.titleViewButton.addTarget(self, action: #selector(presentPickerView(_ :)), for: .touchUpInside)
        mainView.titleViewDatePicker.date = memoryDate

        var attributedTitle = AttributedString(memoryDate.dateToString(type: .simple))
        attributedTitle.font = UIFont(name: CustomFont.medium, size: 16)
        mainView.titleViewButton.configuration?.attributedTitle = attributedTitle
        navigationItem.titleView = mainView.titleViewButton
        
        mainView.titleViewDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

    }
    
    override func configure() {
        super.configure()
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.petCollectionView.delegate = self
        mainView.petCollectionView.dataSource = self
        mainView.contentTextView.delegate = self
        
    }
    
    private func presentPHPickerViewController() {
        var configuartion = PHPickerConfiguration()
        configuartion.filter = .images
        
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        transition(picker, transitionStyle: .presentModally)
    }
    
    private func setDatePickerSheet() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            
            guard let self = self else { return }

            self.memoryDate = self.tempDate
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            
            self.mainView.titleViewDatePicker.date = self.memoryDate
            
        }
        let contentViewController = UIViewController()
        contentViewController.view = mainView.titleViewDatePicker
        contentViewController.preferredContentSize.height = 200
        
        //selectedDate = "\(Int(Date().dateToString(type: .onlyYear))!)"
        
        alert.setValue(contentViewController, forKey: "contentViewController")
        alert.addAction(select)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    //MARK: - @objc
    
    @objc private func presentPickerView(_ sender: UIButton) {
        setDatePickerSheet()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        tempDate = sender.date
    }
    
    @objc private func finishWriting() {
        withList.removeAll()
        mainView.petCollectionView.indexPathsForSelectedItems?.forEach {
            withList.append(petList[$0.item].petName)
        }
        
        //MARK: 선택된 펫이 없는 경우, 제목이 없는 경우에 alert
        if withList.count == 0 && mainView.titleTextField.text! == "" {
            noHandlerAlert(title: "", message: "제목을 입력해주세요.")
        } else if withList.count != 0 && mainView.titleTextField.text! == "" {
            noHandlerAlert(title: "", message: "제목을 입력해주세요.")
        } else if withList.count == 0 && mainView.titleTextField.text! != "" {
            noHandlerAlert(title: "", message: "함께한 반려동물을 선택해주세요.")
        } else {
            //MARK: 새로 작성
            if currentStatus == CurrentStatus.new {
                if mainView.contentTextView.textColor == .placeholderColor {
                    let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDateString: memoryDate.dateToString(type: .simple), petList: withList, memoryContent: "", imageData: imageList, memoryDate: memoryDate, objectId: "\(Date())")
                    
                    repository.addMemory(item: task)
                    transition(self, transitionStyle: .dismiss)
                } else {
                    let task = UserMemory(memoryTitle: mainView.titleTextField.text!, memoryDateString: memoryDate.dateToString(type: .simple), petList: withList, memoryContent: mainView.contentTextView.text, imageData: imageList, memoryDate: memoryDate, objectId: "\(Date())")
                    repository.addMemory(item: task)
                    transition(self, transitionStyle: .dismiss)
                }
            } else {
                //MARK: 편집
                if mainView.contentTextView.textColor == .placeholderColor {
                    if let task = currentTask {
                        repository.updateMemory(item: task, title: mainView.titleTextField.text!, memoryDateString: memoryDate.dateToString(type: .simple), content: "", petList: withList, imageData: imageList, memoryDate: memoryDate)
                    }
                    settingDetailView?()
                    showAlert(title: "수정 완료!")
                } else {
                    if let task = currentTask {
                        repository.updateMemory(item: task, title: mainView.titleTextField.text!, memoryDateString: memoryDate.dateToString(type: .simple), content: mainView.contentTextView.text, petList: withList, imageData: imageList, memoryDate: memoryDate)
                    }
                    settingDetailView?()
                    showAlert(title: "수정 완료!")
                }
            }
        }
    }
    
    @objc private func cancelWriting() {
        //alert띄워서 지울지말지 확인
        if mainView.titleTextField.text?.count != 0 || mainView.contentTextView.textColor != .placeholderColor || imageList.count != 0 {
            handlerAlert(title: "취소하시겠습니까?", message: "작성중인 내용은 저장되지 않습니다.") { _ in
                self.transition(self, transitionStyle: .dismiss)
            }
        } else {
            transition(self, transitionStyle: .dismiss)
        }
    }
    @objc private func presentPhotoPickerView() {
        if imageList.count <= 1 {
            presentPHPickerViewController()
        } else {
            noHandlerAlert(title: "최대 두 장까지 추가할 수 있습니다.", message: "")
        }
    }
}

//MARK: - CollectionView
extension WritingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.petCollectionView {
            return petList.count
        } else {
            return imageList.count + 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        if collectionView == mainView.petCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingPetCollectionViewCell.identifier, for: indexPath) as? WritingPetCollectionViewCell else { return UICollectionViewCell() }
            cell.nameLabel.text = petList[indexPath.item].petName
            
            if petList.count == 1 {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            
            return cell
        } else {
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoButtonCell.identifier, for: indexPath) as? AddPhotoButtonCell else { return UICollectionViewCell() }
                cell.addButton.addTarget(self, action: #selector(presentPhotoPickerView), for: .touchUpInside)
                
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingImageCollectionViewCell.identifier, for: indexPath) as? WritingImageCollectionViewCell else { return UICollectionViewCell() }
                cell.photoImageView.image = UIImage(data: imageList[indexPath.item - 1])
                cell.deleteButton.tag = indexPath.item - 1
                cell.deleteButton.addTarget(self, action: #selector(deleteImage(_ :)), for: .touchUpInside)
                return cell
            }
        }
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
            if indexPath.item == 0 {
                
                let width = mainView.imageCollectionView.frame.size.height - 60
                
                return CGSize(width: width, height: width)
            } else {
                let width = mainView.imageCollectionView.frame.size.height - 20
                
                return CGSize(width: width + 48, height: width)
            }
        }
    }
    @objc private func deleteImage(_ sender: UIButton) {
        //MARK: 지울건지 alert띄우기
        
        imageList.remove(at: sender.tag)
        mainView.imageCollectionView.reloadData()
    }
}

//MARK: - PHPickerViewController

extension WritingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        transition(self, transitionStyle: .dismiss)
        isSelectingPhoto = true
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
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        imageList.insert(imageData, at: 0)
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

//MARK: - Alert
extension WritingViewController {
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.transition(self, transitionStyle: .dismiss)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
