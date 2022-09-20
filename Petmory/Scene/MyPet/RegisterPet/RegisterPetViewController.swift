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

final class RegisterPetViewController: BaseViewController {
    
    var mainView = RegisterPetView()
    
    let repository = UserRepository()
    
    var gender: String = "" {
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
    
    var profileImage: Data? {
        didSet {
            if let image = profileImage {
                mainView.profileImageView.image = UIImage(data: image)
            }
        }
    }
    
    var birthdayDate = Date()
    
    let birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        
        return datePicker
    }()
    
    var currentStatus = CurrentStatus.new
    
    var task: UserPet?
    
    var navTitle = "반려동물 등록"
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentStatus == CurrentStatus.edit {
            mainView.addButton.configuration?.title = "수정"
            if let task = task {
                //프로필 이미지 설정
                if let imageData = task.profileImage {
//                    mainView.profileImageView.image = UIImage(data: imageData)
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
                //생일
                if let birthdayDate = task.birthday {
                    self.birthdayDate = birthdayDate
                    mainView.birthdayTextField.text = birthdayDate.dateToString(type: .simple)
                    birthdayDatePicker.date = birthdayDate
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
        
        mainView.birthdayTextField.inputView = birthdayDatePicker
        
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
        navigationItem.title = navTitle

        //MARK: - 텍스트필드
        mainView.birthdayTextField.delegate = self
        birthdayDatePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        //툴바
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: mainView.bounds.size.width, height: 40))
        let toolBarDoneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneSelectDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([toolBarCancelButton, flexibleSpace, toolBarDoneButton], animated: true)
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
        transition(picker, transitionStyle: .present)
    }
    
    //MARK: - @objc
    @objc private func finishWriting() {
        //데이터 저장
        
        //MARK: alert띄우기
        if gender == "" && mainView.nameTextField.text! == "" {
            print("이름과 성별은 필수입니다!!")
        } else if gender == "" && mainView.nameTextField.text! != "" {
            print("성별을 선택해주세요")
        } else if gender != "" && mainView.nameTextField.text! == "" {
            print("이름을 입력해주세요.")
        } else {
            if mainView.birthdayTextField.text! == "" {
                //MARK: alert띄워서 확인 누르면 오늘 날짜로 텍스트필드 채우기
                print("생일을 작성하지 않으시면 오늘 날짜로 작성됩니다!")
            } else {
                if profileImage == nil {
                    print("사진을 등록해주세요")
                } else {
                    let pet = UserPet(profileImage: profileImage, petName: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text, registerDate: Date())
                    repository.addPet(item: pet)
                    transition(self, transitionStyle: .dismiss)
                }
            }
            
        }
    }
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
        print(birthdayDate)
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
        
        //일단 기능만
        if let task = task {
            repository.deletePet(item: task)
        }
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func addPet() {
        if currentStatus == CurrentStatus.edit {
            print("edit")
            //MARK: alert띄우기
            if mainView.nameTextField.text! == "" {
                print("이름은 필수입니다!!")
            } else {
                if profileImage == nil {
                    print("사진을 등록해주세요")
                } else {
                    if let task = task {
                        repository.updatePet(item: task, profileImage: profileImage, name: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text)
                        transition(self, transitionStyle: .dismiss)
                    }
                }
            }
        } else {
            print("new")
            //MARK: alert띄우기
            if gender == "" && mainView.nameTextField.text! == "" {
                print("이름과 성별은 필수입니다!!")
            } else if gender == "" && mainView.nameTextField.text! != "" {
                print("성별을 선택해주세요")
            } else if gender != "" && mainView.nameTextField.text! == "" {
                print("이름을 입력해주세요.")
            } else {
                if mainView.birthdayTextField.text! == "" {
                    //MARK: alert띄워서 확인 누르면 오늘 날짜로 텍스트필드 채우기
                    print("생일을 작성하지 않으시면 오늘 날짜로 작성됩니다!")
                } else {
                    if profileImage == nil {
                        print("사진을 등록해주세요")
                    } else {
                        let pet = UserPet(profileImage: profileImage, petName: mainView.nameTextField.text!, birthday: birthdayDate, gender: gender, comment: mainView.memoTextView.text, registerDate: Date())
                        repository.addPet(item: pet)
                        transition(self, transitionStyle: .dismiss)
                    }
                }
                
            }
        }
    }
    @objc private func dismissView() {
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
