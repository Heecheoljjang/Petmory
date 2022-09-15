//
//  AddCalendarViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import FSCalendar

final class AddCalendarViewController: BaseViewController {
    
    private var mainView = AddCalendarView()
    
    private let repository = UserRepository()
    
    private var currentColor = CustomColor.customDefault.rawValue
    
    private var selectedDate = Date().nearestHour()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func setUpController() {
        super.setUpController()
        
        //네비게이션 바버튼
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAddingCalendar))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneAddingCalendar))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton

        //네비게이션바 설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        
    }
    
    override func configure() {
        super.configure()
        
        //날짜 텍스트필드
        mainView.dateTextField.text = selectedDate.nearestHour().dateToString(type: .full)
        mainView.dateTextField.inputView = mainView.datePicker
        mainView.dateTextField.delegate = self
        mainView.datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        
        //색 버튼 액션 -> 제목 옆의 colorView 색 바꿔주기 + 현재 색 저장
        mainView.firstButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.secondButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.thirdButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.fourthButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.fifthButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.sixthButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.seventhButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        
    }
    
    //MARK: - @objc
    @objc private func cancelAddingCalendar() {
        //작성한게 있다면 지울건지 alert
        
        //dismiss
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func doneAddingCalendar() {
        //데이터 추가
        if mainView.titleTextField.text != nil {
            repository.addCalendar(item: UserCalendar(title: mainView.titleTextField.text!, date: selectedDate, dateString: selectedDate.dateToString(type: .simple), color: currentColor, comment: mainView.memoTextView.text, registerDate: Date()))
        } else {
            //제목 작성하라고 alert
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("reloadTableView"), object: nil)
        transition(self, transitionStyle: .dismiss)
    }
    @objc private func changeColorView(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentColor = CustomColor.customRed.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        case 1:
            currentColor = CustomColor.customPink.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        case 2:
            currentColor = CustomColor.customYellow.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        case 3:
            currentColor = CustomColor.customMint.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        case 4:
            currentColor = CustomColor.customGreen.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        case 5:
            currentColor = CustomColor.customBlue.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        case 6:
            currentColor = CustomColor.customPurple.rawValue
            mainView.titleColorView.backgroundColor = UIColor.getCustomColor(currentColor)
        default:
            currentColor = CustomColor.customDefault.rawValue
        }
    }
    @objc private func selectDate(_ sender: UIDatePicker) {
        
        mainView.dateTextField.text = sender.date.dateToString(type: .full)
        selectedDate = sender.date
        print(selectedDate)
    }
}

extension AddCalendarViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        mainView.dateTextField.isUserInteractionEnabled = false
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mainView.dateTextField.isUserInteractionEnabled = true
    }
}

