//
//  RegisterPetViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//

import Foundation
//import UIKit
import PhotosUI
import CropViewController
import RealmSwift
import FirebaseAnalytics

final class RegisterPetViewController: BaseViewController {
    
    private var mainView = RegisterPetView()
    
    private let repository = UserRepository() // x
    
    private var gender: String = "" { //didset은 생각
        didSet {
            if gender == ButtonTitle.boy {
                mainView.boyButton.layer.borderColor = UIColor.diaryColor.cgColor
                mainView.boyButton.configuration?.baseForegroundColor = .diaryColor
                mainView.girlButton.layer.borderColor = UIColor.lightGray.cgColor
                mainView.girlButton.configuration?.baseForegroundColor = .lightGray
            } else {
                mainView.boyButton.layer.borderColor = UIColor.lightGray.cgColor
                mainView.boyButton.configuration?.baseForegroundColor = .lightGray
                mainView.girlButton.layer.borderColor = UIColor.diaryColor.cgColor
                mainView.girlButton.configuration?.baseForegroundColor = .diaryColor
            }
        }
    }
    
    private var profileImage: Data? { //didset은 생각
        didSet {
            if let image = profileImage {
                mainView.profileImageView.image = UIImage(data: image)
            }
        }
    }
    
    private var birthdayDate = Date() // x

    var currentStatus = CurrentStatus.new //x
    
    var task: UserPet? //x
        
    let notificationCenter = UNUserNotificationCenter.current() //x
    
    private var petList: [String] = [] // x
        
    private var memories: Results<UserMemory>! //x
    
    private var currentName: String = "" //x
    
    private var viewModel = RegisterPetViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpView로 처리해보기
        
        petList = repository.fetchPet().map { $0.petName } //x
        memories = repository.fetchAllMemory() //x
                
        if currentStatus == CurrentStatus.edit {
            mainView.addButton.configuration?.title = ButtonTitle.edit
            if let task = task {
                //프로필 이미지 설정
                if let imageData = task.profileImage {
                    profileImage = imageData
                }
                //성별 설정
                if task.gender == ButtonTitle.boy {
                    gender = task.gender

                } else {
                    gender = task.gender

                }
                //이름
                mainView.nameTextField.text = task.petName
                currentName = task.petName
                //생일
                if let birthdayDate = task.birthday {
                    self.birthdayDate = birthdayDate
                    mainView.birthdayTextField.text = birthdayDate.dateToString(type: .simple)
                    mainView.birthdayDatePicker.date = birthdayDate
                }
                //메모
                mainView.memoTextView.text = task.comment
            }
            mainView.deleteButton.isHidden = false
        } else {
            mainView.addButton.configuration?.title = ButtonTitle.register
            mainView.deleteButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageData = profileImage {
            mainView.profileImageView.image = UIImage(data: imageData)
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

    //x
    private func sendNotification(name: String, date: Date, identifier: String) {

        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = "\(name) 생일"
        notificationContent.body = NotificationContentText.happyDay

        var dateComponents = DateComponents()
        dateComponents.month = date.dateComponentFromDate(component: DateComponent.month.rawValue)
        dateComponents.day = date.dateComponentFromDate(component: DateComponent.day.rawValue)
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        notificationCenter.add(request)
    }
    
    //MARK: - @objc

    //MARK: 성별 버튼
    @objc private func tapBoyButton() {
        gender = ButtonTitle.boy
    }
    
    @objc private func tapGirlButton() {
        gender = ButtonTitle.girl
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
        //지울건지 alert띄우고
        handlerAlert(title: AlertTitle.checkDelete, message: "") { [weak self] _ in
            guard let self = self else { return }
            if let task = self.task {
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
                self.repository.deletePet(item: task)
            }
            self.transition(self, transitionStyle: .dismiss)
        }
    }

    @objc private func addPet() {
        
        let currentDate = Date()
    
        //수정인 경우에는 기존의 이름과 다르다면 메모리들의 반려동물 리스트 전부 수정
        if currentStatus == CurrentStatus.edit {

            guard let task = task else { return }
            
            //이름 비어있는지
            if mainView.nameTextField.text! == "" {
                noHandlerAlert(title: AlertTitle.noPetName, message: "")
                return
            }
           
            //이름이 수정되지 않은 경우
            if mainView.nameTextField.text! == currentName {
                updatePetInfo(task)
            }
            
            //추가된 이름들과 겹치는지
            if petList.contains(mainView.nameTextField.text!) {
                noHandlerAlert(title: AlertTitle.alreadyRegisteredName, message: AlertMessage.anotherName)
                return
            }
            
            //이름 안겹침
            memories.filter { $0.petList.contains(self.currentName) }.forEach {
                let tempPetList = List<String>()
                $0.petList.filter { $0 != self.currentName }.forEach { petName in
                    tempPetList.append(petName)
                }
                tempPetList.append(mainView.nameTextField.text!)
                self.repository.updateMemoryPetList(item: $0, petList: tempPetList)
            }
            
            updatePetInfo(task)
            
        } else {
            
            //성별 선택 안함
            if gender == "" {
                noHandlerAlert(title: AlertTitle.noPetGender, message: "")
                return
            }
    
            //이름 작성안함
            if mainView.nameTextField.text! == "" {
                noHandlerAlert(title: AlertTitle.noPetName, message: "")
                return
            }
            
            //생일 없음
            if mainView.birthdayTextField.text! == "" {
                noHandlerAlert(title: AlertTitle.noPetBirthday, message: "")
                return
            }
            
            //사진 없음
            if profileImage == nil {
                noHandlerAlert(title: AlertTitle.noPetProfilePhoto, message: "")
                return
            }
            
            //이름 중복됨
            if petList.contains(mainView.nameTextField.text!) {
                noHandlerAlert(title: AlertTitle.alreadyRegisteredName, message: "")
                return
            }
            
            addPetInfo(currentDate)
        }
    }
    @objc private func dismissView() {
        if gender != "" || mainView.nameTextField.text! != "" || mainView.birthdayTextField.text! != "" || mainView.memoTextView.text! != "" || mainView.profileImageView.image != nil {
            handlerAlert(title: AlertTitle.checkCancel, message: AlertMessage.willNotSave) { _ in
                self.transition(self, transitionStyle: .dismiss)
            }
        } else {
            self.transition(self, transitionStyle: .dismiss)
        }
    }
}

extension RegisterPetViewController {
    
    private func updatePetInfo(_ task: UserPet) {
        Analytics.logEvent("Update_Pet", parameters: [
            "name": "Update Pet NotName",
        ])
        repository.updatePet(item: task, profileImage: profileImage, name: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
        sendNotification(name: mainView.nameTextField.text!, date: birthdayDate, identifier: "\(task.registerDate)")
        transition(self, transitionStyle: .dismiss)
    }
    
    private func addPetInfo(_ currentDate: Date) {
        let pet = UserPet(profileImage: profileImage, petName: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text, registerDate: currentDate)
        Analytics.logEvent("Add_Pet", parameters: [
            "name": "Add Pet",
        ])
        repository.addPet(item: pet)
        sendNotification(name: mainView.nameTextField.text!, date: birthdayDate, identifier: "\(currentDate)")
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
        
        profileImage = imageData
        
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
