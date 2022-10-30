//
//  RegisterPetViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//
import UIKit
import PhotosUI
import CropViewController
import RealmSwift
import FirebaseAnalytics

final class RegisterPetViewController: BaseViewController {
    
    private var mainView = RegisterPetView()
    
    private var birthdayDate = Date()
    
    var currentStatus = CurrentStatus.new
    
    var task: UserPet?
        
    private var petList: [String] = []
    
    private var memories: Results<UserMemory>!
    
    private var currentName: String = ""
    
    private var viewModel = RegisterPetViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()

        petList = viewModel.fetchPetList()
        memories = viewModel.fetchMemories()
        
        if currentStatus == CurrentStatus.edit {
            
            guard let task = task, let imageData = task.profileImage, let birthday = task.birthday else { return }
            
            mainView.addButton.configuration?.title = ButtonTitle.edit
            
            //MARK: 프로필 이미지 설정
            viewModel.profileImage.value = imageData
            
            //MARK: 성별 설정
            viewModel.gender.value = task.gender
            
            //MARK: 이름
            mainView.nameTextField.text = task.petName
            currentName = task.petName
            
            //MARK: 생일
            birthdayDate = birthday
            mainView.birthdayTextField.text = birthday.dateToString(type: .simple)
            mainView.birthdayDatePicker.date = birthday
            
            //MARK: 메모
            mainView.memoTextView.text = task.comment
            mainView.deleteButton.isHidden = false
                        
        } else {
            
            mainView.addButton.configuration?.title = ButtonTitle.register
            mainView.deleteButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageData = viewModel.profileImage.value {
            mainView.profileImageView.image = UIImage(data: imageData)
        }
    }
    
    private func bind() {
        
        viewModel.gender.bind { [weak self] value in
            
            if value == ButtonTitle.boy {
                
                self?.mainView.boyButton.layer.borderColor = UIColor.diaryColor.cgColor
                self?.mainView.boyButton.configuration?.baseForegroundColor = .diaryColor
                self?.mainView.girlButton.layer.borderColor = UIColor.lightGray.cgColor
                self?.mainView.girlButton.configuration?.baseForegroundColor = .lightGray
                
            } else if value == ButtonTitle.girl {
                
                self?.mainView.boyButton.layer.borderColor = UIColor.lightGray.cgColor
                self?.mainView.boyButton.configuration?.baseForegroundColor = .lightGray
                self?.mainView.girlButton.layer.borderColor = UIColor.diaryColor.cgColor
                self?.mainView.girlButton.configuration?.baseForegroundColor = .diaryColor
                
            }
        }
        
        viewModel.profileImage.bind { [weak self] image in
            
            if let image = image {
                self?.mainView.profileImageView.image = UIImage(data: image)
            }
        }
    }
    
    override func configure() {
        super.configure()
        
        mainView.birthdayTextField.inputView = mainView.birthdayDatePicker
        
    }
    
    override func setUpController() {
        super.setUpController()
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        tabBarController?.tabBar.isHidden = true
        
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: ImageName.xmark), style: .plain, target: self, action: #selector(dismissView))
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.titleView = mainView.titleLabel
        
        //MARK: - 텍스트필드
        
        mainView.birthdayTextField.delegate = self
        mainView.birthdayDatePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        //툴바
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: mainView.bounds.size.width, height: 40))
        let toolBarDoneButton = UIBarButtonItem(title: ButtonTitle.done, style: .plain, target: self, action: #selector(doneSelectDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarCancelButton = UIBarButtonItem(title: ButtonTitle.cancel, style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([toolBarCancelButton, flexibleSpace, toolBarDoneButton], animated: true)
        toolBar.tintColor = .diaryColor
        mainView.birthdayTextField.inputAccessoryView = toolBar
        
        //MARK: - 버튼 액션
        
        //성별 버튼
        mainView.boyButton.addTarget(self, action: #selector(tapBoyButton), for: .touchUpInside)
        mainView.girlButton.addTarget(self, action: #selector(tapGirlButton), for: .touchUpInside)
        
        //사진 버튼
        mainView.photoButton.addTarget(self, action: #selector(presentPhotoPickerView), for: .touchUpInside)
        
        //등록, 삭제 버튼
        mainView.deleteButton.addTarget(self, action: #selector(deletePet), for: .touchUpInside)
        mainView.addButton.addTarget(self, action: #selector(addPet), for: .touchUpInside)
    }
    
    private func presentPHPickerViewController() {
        var configuartion = PHPickerConfiguration()
        configuartion.filter = .images
        
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        transition(picker, transitionStyle: .presentModally)
    }

    //MARK: - @objc
    
    //MARK: 성별 버튼
    @objc private func tapBoyButton() {
        viewModel.gender.value = ButtonTitle.boy
    }
    
    @objc private func tapGirlButton() {
        viewModel.gender.value = ButtonTitle.girl
    }
    
    //MARK: 사진 버튼
    @objc private func presentPhotoPickerView() {
        presentPHPickerViewController()
    }
    
    //MARK: 날짜 선택
    @objc private func selectDate(_ sender: UIDatePicker) {
        birthdayDate = sender.date
    }
    @objc private func doneSelectDate() {
        
        mainView.birthdayTextField.text = birthdayDate.dateToString(type: .simple)
        
        mainView.birthdayTextField.endEditing(true)
    }
    @objc private func dismissPicker() {
        mainView.birthdayTextField.endEditing(true)
    }
    @objc private func deletePet() {
        handlerAlert(title: AlertTitle.checkDelete, message: "") { [weak self] _ in
            guard let self = self, let task = self.task else { return }
            
            self.viewModel.removeNoti(identifier: "\(task.registerDate)")
            self.viewModel.deletePet(item: task)
            
            self.transition(self, transitionStyle: .dismiss)
        }
    }
    
    @objc private func addPet() {
        
        let currentDate = Date()
        
        switch currentStatus {
        case CurrentStatus.edit:
            
        case CurrentStatus.new:
            
        }
        
        //switch -> 가독형
        if currentStatus == CurrentStatus.edit {
            
            guard let task = task else { return }

            if viewModel.checkName(name: mainView.nameTextField.text!, text: "") {
                noHandlerAlert(title: AlertTitle.noPetName, message: "")
                return
            }
            
            //이름이 수정되지 않은 경우

            if viewModel.checkName(name: mainView.nameTextField.text!, text: currentName) {
                updatePetInfo(task)
                return
            }
            
            //추가된 이름들과 겹치는지

            if viewModel.checkNameEqual(petList: petList, name: mainView.nameTextField.text!) {
                noHandlerAlert(title: AlertTitle.alreadyRegisteredName, message: AlertMessage.anotherName)
                return
            }
            
            //이름 안겹침
            viewModel.updateMemoryPetList(memories: memories, currentName: currentName, newName:  mainView.nameTextField.text!)
            
            updatePetInfo(task)
            
        } else {
            
            //성별 선택 안함

            if viewModel.checkGenderEmpty(gender: viewModel.gender.value) {
                noHandlerAlert(title: AlertTitle.noPetGender, message: "")
                return
            }
            
            //이름 작성안함

            if viewModel.checkName(name: mainView.nameTextField.text!, text: "") {
                noHandlerAlert(title: AlertTitle.noPetName, message: "")
                return
            }
            
            //생일 없음

            if viewModel.checkBirthdayEmpty(birthday: mainView.birthdayTextField.text!) {
                noHandlerAlert(title: AlertTitle.noPetBirthday, message: "")
                return
            }
            
            //사진 없음

            if viewModel.checkProfileImageNil(image: viewModel.profileImage.value) {
                noHandlerAlert(title: AlertTitle.noPetProfilePhoto, message: "")
                return
            }
            
            //이름 중복됨

            if viewModel.checkNameEqual(petList: petList,name: mainView.nameTextField.text!) {
                noHandlerAlert(title: AlertTitle.alreadyRegisteredName, message: "")
                return
            }
            
            addPetInfo(currentDate)
        }
    }
    @objc private func dismissView() {

        guard let name = mainView.nameTextField.text, let birthday = mainView.birthdayTextField.text, let memo = mainView.memoTextView.text else { return }
        
        if viewModel.checkDismiss(gender: viewModel.gender.value, name: name, birthday: birthday, memo: memo, image: viewModel.profileImage.value) {
            handlerAlert(title: AlertTitle.checkCancel, message: AlertMessage.willNotSave) { [weak self] _ in
                guard let self = self else { return }
                self.transition(self, transitionStyle: .dismiss)
            }
        } else {
            transition(self, transitionStyle: .dismiss)
        }
    }
}


extension RegisterPetViewController {
    
    private func updatePetInfo(_ task: UserPet) {
        Analytics.logEvent("Update_Pet", parameters: [
            "name": "Update Pet NotName",
        ])

        guard let profileImage = viewModel.profileImage.value, let name = mainView.nameTextField.text, let comment = mainView.memoTextView.text else { return }
        
        viewModel.updatePet(task: task, profileImage: profileImage, name: name, birthday: birthdayDate, gender: viewModel.gender.value, comment: comment)
        viewModel.removeNoti(identifier: "\(task.registerDate)")
        viewModel.sendNotification(name: name, date: birthdayDate, identifier: "\(task.registerDate)")
        
        transition(self, transitionStyle: .dismiss)
    }
    
    private func addPetInfo(_ currentDate: Date) {
        
        guard let profileImage = viewModel.profileImage.value, let name = mainView.nameTextField.text, let comment = mainView.memoTextView.text else { return }
        
        let pet = UserPet(profileImage: profileImage, petName: name, birthday: birthdayDate, gender: viewModel.gender.value, comment: comment, registerDate: currentDate)
        Analytics.logEvent("Add_Pet", parameters: [
            "name": "Add Pet",
        ])

        viewModel.addPet(item: pet)
        viewModel.sendNotification(name: name, date: birthdayDate, identifier: "\(currentDate)")
        transition(self, transitionStyle: .dismiss)
    }
}

extension RegisterPetViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        transition(self, transitionStyle: .dismiss)
        
        //편집 띄우기
        let itemProvider = results.first?.itemProvider
        
        itemProvider?.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                let cropViewController = CropViewController(croppingStyle: .circular, image: selectedImage)
                cropViewController.delegate = self
                cropViewController.doneButtonColor = .stringColor
                cropViewController.cancelButtonColor = .stringColor
                cropViewController.doneButtonTitle = ButtonTitle.done
                cropViewController.cancelButtonTitle = ButtonTitle.cancel
                self.transition(cropViewController, transitionStyle: .present)
                
            }
        }
    }
}

extension RegisterPetViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        viewModel.profileImage.value = imageData
        
        transition(self, transitionStyle: .dismiss)
    }
}

extension RegisterPetViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        mainView.birthdayTextField.isUserInteractionEnabled = false
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mainView.birthdayTextField.isUserInteractionEnabled = true
    }
}
