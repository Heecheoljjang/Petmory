//
//  RegisterPetViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/11.
//

import Foundation
import UIKit
import PhotosUI
import CropViewController
import RealmSwift
import FirebaseAnalytics

final class RegisterPetViewController: BaseViewController {
    
    private var mainView = RegisterPetView()
    
    private let repository = UserRepository()
    
    private var gender: String = "" {
        didSet {
            if gender == "남아" {
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
    
    private var profileImage: Data? {
        didSet {
            if let image = profileImage {
                mainView.profileImageView.image = UIImage(data: image)
            }
        }
    }
    
    private var birthdayDate = Date()

    var currentStatus = CurrentStatus.new
    
    var task: UserPet?
        
    let notificationCenter = UNUserNotificationCenter.current()
    
    private var petList: [String] = []
    
    private var memories: Results<UserMemory>!
    
    private var currentName: String = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petList = repository.fetchPet().map { $0.petName }
        memories = repository.fetchAllMemory()
                
        if currentStatus == CurrentStatus.edit {
            mainView.addButton.configuration?.title = "수정"
            if let task = task {
                //프로필 이미지 설정
                if let imageData = task.profileImage {
                    profileImage = imageData
                }
                //성별 설정
                if task.gender == "남아" {
                    gender = task.gender
                    mainView.boyButton.configuration?.baseForegroundColor = .diaryColor
                    mainView.boyButton.layer.borderColor = UIColor.diaryColor.cgColor
                } else {
                    gender = task.gender
                    mainView.girlButton.configuration?.baseForegroundColor = .diaryColor
                    mainView.girlButton.layer.borderColor = UIColor.diaryColor.cgColor
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
            mainView.addButton.configuration?.title = "등록"
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
        
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
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
        let toolBarDoneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneSelectDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissPicker))
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

    private func sendNotification(name: String, date: Date, identifier: String) {

        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = "\(name) 생일"
        notificationContent.body = "소중한 하루를 선물해주세요 :)"

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
        gender = "남아"
    }
    
    @objc private func tapGirlButton() {
        gender = "여아"
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
        handlerAlert(title: "삭제하시겠습니까?", message: "") { [weak self] _ in
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
            //MARK: alert띄우기
            if mainView.nameTextField.text! == "" {
                noHandlerAlert(title: "이름을 입력해주세요.", message: "")
            } else {
                if profileImage == nil {
                    noHandlerAlert(title: "사진을 등록해주세요.", message: "")
                } else {
                    //중복체크. 이름이 바뀌었는지부터 체크하고 안바뀌었다면 바로 수정, 바뀌었다면 중복체크하고 중복되지않는다면 수정하고 반려동물 리스트 업데이트
                    if mainView.nameTextField.text! == currentName {
                        if let task = task {
                            Analytics.logEvent("Update_Pet", parameters: [
                                "name": "Update Pet NotName",
                            ])
                            repository.updatePet(item: task, profileImage: profileImage, name: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text)
                            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
                            sendNotification(name: mainView.nameTextField.text!, date: birthdayDate, identifier: "\(task.registerDate)")
                            transition(self, transitionStyle: .dismiss)
                        }
                    } else {
                        //이름이 바뀐 것이므로 중복체크
                        if petList.contains(mainView.nameTextField.text!) {
                            noHandlerAlert(title: "이미 등록된 이름입니다.", message: "다른 이름을 사용해주세요.")
                        } else {
                            //리스트 업데이트하고, 펫도 업데이트. 근데 메모리의 반려동물 리스트안에 currentName이 포함되어 있어야함.
                            memories.forEach {
                                if $0.petList.contains(currentName) {
                                    var tempPetList = List<String>()
                                    $0.petList.forEach { petName in
                                        if petName != currentName {
                                            tempPetList.append(petName)
                                        }
                                    }
                                    tempPetList.append(mainView.nameTextField.text!)
                                    self.repository.updateMemoryPetList(item: $0, petList: tempPetList)
                                }
                            }
                            
                            if let task = task {
                                Analytics.logEvent("Update_Pet", parameters: [
                                    "name": "Update Pet Name Too",
                                ])
                                repository.updatePet(item: task, profileImage: profileImage, name: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text)
                                notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
                                sendNotification(name: mainView.nameTextField.text!, date: birthdayDate, identifier: "\(task.registerDate)")
                                transition(self, transitionStyle: .dismiss)
                            }
                        }
                    }
                }
            }
        } else {
            //MARK: alert띄우기
            if gender == "" && mainView.nameTextField.text! == "" {
                noHandlerAlert(title: "이름을 입력해주세요.", message: "")
            } else if gender == "" && mainView.nameTextField.text! != "" {
                noHandlerAlert(title: "성별을 선택해주세요.", message: "")
            } else if gender != "" && mainView.nameTextField.text! == "" {
                noHandlerAlert(title: "이름을 입력해주세요.", message: "")
            } else {
                if mainView.birthdayTextField.text! == "" {
                    //MARK: alert띄워서 확인 누르면 오늘 날짜로 텍스트필드 채우기
                    noHandlerAlert(title: "생일을 입력해주세요.", message: "")
                } else {
                    if profileImage == nil {
                        noHandlerAlert(title: "사진을 등록해주세요.", message: "")
                    } else {
                        //이름만 중복체크하기
                        if petList.contains(mainView.nameTextField.text!) {
                            noHandlerAlert(title: "이미 등록된 이름입니다.", message: "다른 이름을 사용해주세요.")
                        } else {
                            let pet = UserPet(profileImage: profileImage, petName: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text, registerDate: currentDate)
                            Analytics.logEvent("Add_Pet", parameters: [
                                "name": "Add Pet",
                            ])
                            repository.addPet(item: pet)
                            sendNotification(name: mainView.nameTextField.text!, date: birthdayDate, identifier: "\(currentDate)")
                            transition(self, transitionStyle: .dismiss)
                        }
                    }
                }
                
            }
        }
    }
    @objc private func dismissView() {
        if gender != "" || mainView.nameTextField.text! != "" || mainView.birthdayTextField.text! != "" || mainView.memoTextView.text! != "" || mainView.profileImageView.image != nil {
            handlerAlert(title: "취소하시겠습니까?", message: "작성중인 내용은 저장되지 않습니다.") { _ in
                self.transition(self, transitionStyle: .dismiss)
            }
        } else {
            self.transition(self, transitionStyle: .dismiss)
        }
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
                cropViewController.doneButtonTitle = "완료"
                cropViewController.cancelButtonTitle = "취소"
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
