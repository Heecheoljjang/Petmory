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
    
    let placeholderText = "오늘 하루를 어떻게 보내셨나요?"
    
    var currentTask: UserMemory?
    
    var memoryDate = Date() {
        didSet {
//            titleViewTextField.text = memoryDate.dateToString(type: .simple)
            titleViewDatePicker.date = memoryDate
        }
    }
    
    //사진 고를때 잠깐 보이는 시점인지 확인하는 프로퍼티
    var isSelectingPhoto = false
    
    var settingDetailView: (() -> ())?
    
    let titleViewTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.medium, size: 18)
        textField.textAlignment = .center
        textField.tintColor = .clear
        
        return textField
    }()
    
    let titleViewDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        
        return datePicker
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList = repository.fetchPet()
        
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
        titleViewDatePicker.date = memoryDate
        titleViewTextField.inputView = titleViewDatePicker
        titleViewTextField.text = memoryDate.dateToString(type: .simple)
        navigationItem.titleView = titleViewTextField
    
        mainView.imageCollectionView.reloadData()
        
        print(imageList)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NotificationCenter.default.post(name: NSNotification.Name.reloadCollectionView, object: nil)
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
                
        //MARK: 액션 추가
        mainView.pickButton.addTarget(self, action: #selector(presentPhotoPickerView), for: .touchUpInside)
        
        //MARK: 텍스트뷰
        mainView.contentTextView.text = placeholderText
        mainView.contentTextView.textColor = .placeholderColor
                
        //MARK: 네비게이션 타이틀 뷰
//        titleViewDatePicker.date = memoryDate
//        titleViewTextField.inputView = titleViewDatePicker
//        titleViewTextField.text = memoryDate.dateToString(type: .simple)
        titleViewTextField.delegate = self
        titleViewDatePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        //툴바
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: mainView.bounds.size.width, height: 40))
        let toolBarDoneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneSelectDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([toolBarCancelButton, flexibleSpace, toolBarDoneButton], animated: true)
        titleViewTextField.inputAccessoryView = toolBar
        
        //navigationItem.titleView = titleViewTextField
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
    
    //MARK: - @objc
    @objc private func finishWriting() {
        withList.removeAll()
        mainView.petCollectionView.indexPathsForSelectedItems?.forEach {
            withList.append(petList[$0.item].petName)
        }
        //let currentDate = Date()
        
        //MARK: 선택된 펫이 없는 경우, 제목이 없는 경우에 alert
        if withList.count == 0 && mainView.titleTextField.text! == "" {
            noHandlerAlert(title: "", message: "제목을 입력해주세요.")
        } else if withList.count != 0 && mainView.titleTextField.text! == "" {
            noHandlerAlert(title: "", message: "제목을 입력해주세요.")
        } else if withList.count == 0 && mainView.titleTextField.text! != "" {
            print("함께한 반려동물을 선택해주세요")
            noHandlerAlert(title: "", message: "함께 보낸 반려동물을 선택해주세요.")
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
//                    NotificationCenter.default.post(name: NSNotification.Name.editWriting, object: nil)
                    settingDetailView?()
//                    transition(self, transitionStyle: .dismiss)
                    showAlert(title: "수정 완료!")
                } else {
                    if let task = currentTask {
                        repository.updateMemory(item: task, title: mainView.titleTextField.text!, memoryDateString: memoryDate.dateToString(type: .simple), content: mainView.contentTextView.text, petList: withList, imageData: imageList, memoryDate: memoryDate)
                    }
//                    NotificationCenter.default.post(name: NSNotification.Name.editWriting, object: nil)
                    settingDetailView?()
//                    transition(self, transitionStyle: .dismiss)
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
            print("No")
        }
    }
    @objc private func selectDate(_ sender: UIDatePicker) {
        
        memoryDate = sender.date
        
    }
    @objc private func doneSelectDate() {
        titleViewTextField.text = memoryDate.dateToString(type: .simple)
        titleViewTextField.endEditing(true)
    }
    @objc private func dismissPicker() {
        titleViewTextField.endEditing(true)
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
    
    
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == mainView.petCollectionView {
//
//        } else {
//            let cell = collectionView.cellForItem(at: indexPath)
//            cell?.isSelected = true
//        }
//    }
    
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
        print(imageList)
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
                cropViewController.doneButtonColor = .diaryColor
                cropViewController.cancelButtonColor = .diaryColor
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

extension WritingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        titleViewTextField.isUserInteractionEnabled = false
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleViewTextField.isUserInteractionEnabled = true
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
