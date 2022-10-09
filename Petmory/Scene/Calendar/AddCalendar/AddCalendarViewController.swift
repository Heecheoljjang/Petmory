//
//  AddCalendarViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/14.
//

import UIKit
import FSCalendar
import RealmSwift
import FirebaseAnalytics

final class AddCalendarViewController: BaseViewController {
    
    private var mainView = AddCalendarView()
    
    private let repository = UserRepository()
    
    private var currentColor = CustomColor.customDefault.rawValue
    
    var currentStatus = CurrentStatus.new

    var selectedDate: Date?
    
    var task: UserCalendar?
        
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func setUpController() {
        super.setUpController()
        
        //네비게이션 바버튼
        let cancelButton = UIBarButtonItem(title: ButtonTitle.cancel, style: .plain, target: self, action: #selector(cancelAddingCalendar))
        let doneButton = UIBarButtonItem(title: ButtonTitle.done, style: .plain, target: self, action: #selector(doneAddingCalendar))
        let deleteButton = UIBarButtonItem(title: ButtonTitle.delete, style: .plain, target: self, action: #selector(deleteCalendar))
        navigationItem.rightBarButtonItem = doneButton
        
        if currentStatus == CurrentStatus.edit {
            navigationItem.leftBarButtonItem = deleteButton
        } else {
            navigationItem.leftBarButtonItem = cancelButton
        }

        //네비게이션바 설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.dateTextField.delegate = self
        mainView.datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        mainView.dateTextField.inputView = mainView.datePicker

        //색 버튼 액션 -> 제목 옆의 colorView 색 바꿔주기 + 현재 색 저장
        mainView.firstButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.secondButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.thirdButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.fourthButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.fifthButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.sixthButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        mainView.seventhButton.addTarget(self, action: #selector(changeColorView(_ :)), for: .touchUpInside)
        
        mainView.memoTextView.delegate = self
        mainView.titleTextView.delegate = self
        
        if currentStatus == CurrentStatus.new {
            //날짜 텍스트필드

            selectedDate = selectedDate?.nearestHour()
            
            mainView.titleTextView.text = PlaceholderText.title
            mainView.titleTextView.textColor = .placeholderColor

            mainView.dateTextField.text = selectedDate!.dateToString(type: .full)
            mainView.datePicker.date = selectedDate!
            
            //메모 텍스트뷰
            mainView.memoTextView.text = PlaceholderText.memo
            mainView.memoTextView.textColor = .placeholderColor
        } else {
            if let task = task {
                currentColor = task.color
                mainView.titleTextView.text = task.title
                mainView.titleColorView.backgroundColor = .setCustomColor(task.color)
                mainView.dateTextField.text = task.date.dateToString(type: .full)
                if task.comment == "" {
                    mainView.memoTextView.text = PlaceholderText.memo
                    mainView.memoTextView.textColor = .placeholderColor
                } else {
                    mainView.memoTextView.text = task.comment
                    mainView.memoTextView.textColor = .black
                }
                mainView.datePicker.date = task.date
            }
        }
    }
    
    //MARK: - 알림
    private func sendNotification(body: String, date: Date, identifier: String) {
 
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = NotificationContentText.todayCalendar
        notificationContent.body = body

        var dateComponents = DateComponents()
        dateComponents.year = date.dateComponentFromDate(component: DateComponent.year.rawValue)
        dateComponents.month = date.dateComponentFromDate(component: DateComponent.month.rawValue)
        dateComponents.day = date.dateComponentFromDate(component: DateComponent.day.rawValue)
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    //MARK: - @objc
    @objc private func cancelAddingCalendar() {
        //작성한게 있다면 지울건지 alert
        if mainView.titleTextView.text?.count != 0 || mainView.memoTextView.textColor != .placeholderColor {
            handlerAlert(title: AlertTitle.checkCancel, message: AlertMessage.willNotSave) { _ in
                self.transition(self, transitionStyle: .dismiss)
            }
        } else {
            self.transition(self, transitionStyle: .dismiss)
        }
    }
    @objc private func doneAddingCalendar() {
        
        let currentDate = Date()
        
        if currentStatus == CurrentStatus.new {
            //데이터 추가
            if mainView.titleTextView.textColor != .placeholderColor || mainView.titleTextView.text != "" {
                Analytics.logEvent("Add_New_Calendar", parameters: [
                    "name": "New Calendar",
                ])
                if mainView.memoTextView.textColor == .placeholderColor {
                    repository.addCalendar(item: UserCalendar(title: mainView.titleTextView.text!, date: selectedDate!, dateString: selectedDate!.dateToString(type: .simple), color: currentColor, comment: "", registerDate: currentDate))
                    if selectedDate! > Date() {
                        sendNotification(body: mainView.titleTextView.text!, date: selectedDate!, identifier: "\(currentDate)")
                    }
                    NotificationCenter.default.post(name: NSNotification.Name.doneButton, object: nil)
                    transition(self, transitionStyle: .dismiss)
                } else {
                    repository.addCalendar(item: UserCalendar(title: mainView.titleTextView.text!, date: selectedDate!, dateString: selectedDate!.dateToString(type: .simple), color: currentColor, comment: mainView.memoTextView.text, registerDate: currentDate))
                    if selectedDate! > Date() {
                        sendNotification(body: mainView.titleTextView.text!, date: selectedDate!, identifier: "\(currentDate)")
                    }
                    NotificationCenter.default.post(name: NSNotification.Name.doneButton, object: nil)
                    transition(self, transitionStyle: .dismiss)
                }
            } else {
                //제목 작성하라고 alert
                noHandlerAlert(title: AlertMessage.noTitle, message: "")
            }
        } else {
            //데이터 수정
            if let task = task {
                if task.title != mainView.titleTextView.text! || task.color != currentColor || task.date != selectedDate! || task.comment != mainView.memoTextView.text {
                    if mainView.titleTextView.textColor == .placeholderColor || mainView.titleTextView.text == "" {
                        //제목 입력하라고 alert
                        noHandlerAlert(title: AlertMessage.noTitle, message: "")
                    } else {
                        Analytics.logEvent("Update_Calendar", parameters: [
                            "name": "Update Calendar",
                        ])
                        if mainView.memoTextView.textColor == .placeholderColor {
                            repository.updateCalendar(item: task, title: mainView.titleTextView.text!, date: selectedDate!, dateString: selectedDate!.dateToString(type: .simple),color: currentColor, comment: "")
                            //알림 지우고 다시 등록
                            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
                            if selectedDate! > Date() {
                                sendNotification(body: mainView.titleTextView.text!, date: selectedDate!, identifier: "\(currentDate)")
                            }
                            NotificationCenter.default.post(name: NSNotification.Name.doneButton, object: nil)
                            transition(self, transitionStyle: .dismiss)
                        } else {
                            repository.updateCalendar(item: task, title: mainView.titleTextView.text!, date: selectedDate!, dateString: selectedDate!.dateToString(type: .simple),color: currentColor, comment: mainView.memoTextView.text)
                            //알림 지우고 다시 등록
                            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
                            if selectedDate! > Date() {
                                sendNotification(body: mainView.titleTextView.text!, date: selectedDate!, identifier: "\(currentDate)")
                            }
                            NotificationCenter.default.post(name: NSNotification.Name.doneButton, object: nil)
                            transition(self, transitionStyle: .dismiss)
                        }
                    }
                } else {
                    transition(self, transitionStyle: .dismiss)
                }
            }
        }
    }
    @objc private func changeColorView(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentColor = CustomColor.customRed.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        case 1:
            currentColor = CustomColor.customPink.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        case 2:
            currentColor = CustomColor.customYellow.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        case 3:
            currentColor = CustomColor.customMint.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        case 4:
            currentColor = CustomColor.customGreen.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        case 5:
            currentColor = CustomColor.customBlue.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        case 6:
            currentColor = CustomColor.customPurple.rawValue
            mainView.titleColorView.backgroundColor = UIColor.setCustomColor(currentColor)
        default:
            currentColor = CustomColor.customDefault.rawValue
        }
    }
    @objc private func selectDate(_ sender: UIDatePicker) {
        
        mainView.dateTextField.text = sender.date.dateToString(type: .full)
        selectedDate = sender.date
    }
    @objc private func deleteCalendar() {
        handlerAlert(title: AlertTitle.checkDelete, message: "") { [weak self] _ in
            
            guard let self = self else { return }
            
            if let task = self.task {
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(task.registerDate)"])
                self.repository.deleteCalendar(item: task)
                NotificationCenter.default.post(name: NSNotification.Name.deleteButton, object: nil)
                self.transition(self, transitionStyle: .dismiss)
            }
        }
        
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

extension AddCalendarViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderColor {
            textView.textColor = .black
            textView.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == mainView.contentView {
            if textView.text == "" {
                textView.text = PlaceholderText.memo
                textView.textColor = .placeholderColor
            }
        } else {
            if textView.text == "" {
                textView.text = PlaceholderText.title
                textView.textColor = .placeholderColor
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == mainView.titleTextView {
            if textView.text.count > 150 {
                textView.deleteBackward()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == mainView.titleTextView {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
        return true
    }
}
