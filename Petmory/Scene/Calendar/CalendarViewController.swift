//
//  CalendarViewController.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//

import Foundation
import UIKit
import FSCalendar
import RealmSwift
import SnapKit

final class CalendarViewController: BaseViewController {
    
    var mainView = CalendarView()
    
    var memories: Results<UserMemory>! {
        didSet {
            //print("memories: \(memories)")
        }
    }
    
    var calendarTask: Results<UserCalendar>! {
        didSet {
            //print(calendarTask)
            if calendarTask.count == 0 {
                mainView.tableView.isHidden = true
                mainView.noTaskLabel.isHidden = false
            } else {
                mainView.tableView.isHidden = false
                mainView.noTaskLabel.isHidden = true
            }
            mainView.tableView.reloadData()
        }
    }
    
    var selectDate = Date() {
        didSet {
            datePicker.date = selectDate
            mainView.dateLabel.text = selectDate.dateToString(type: .simpleDay)
            mainView.tableView.reloadData()
        }
    }
    
    let repository = UserRepository()
    
    //헤더뷰
    let customTitleView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var dateButtonTitle = Date().dateToString(type: .yearMonth) {
        didSet {
            navigationItem.leftBarButtonItem?.title = dateButtonTitle
        }
    }
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        datePicker.locale = Locale(identifier: "ko-KR")
        
        return datePicker
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateButtonTitle = selectDate.dateToString(type: .yearMonth)
        
        calendarTask = repository.fetchCalendar(date: Date())
        
        mainView.dateLabel.text = Date().dateToString(type: .simpleDay)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_ :)), name: NSNotification.Name.doneButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_ :)), name: NSNotification.Name.deleteButton, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mainView.tableView.reloadData()
        mainView.calendar.reloadData()
    }

    override func configure() {
        super.configure()
                
    }
    
    override func setUpController() {
        super.setUpController()
        
        let addButton = UIBarButtonItem(title: "오늘", style: .plain, target: self, action: #selector(setToday))
        let dateButton = UIBarButtonItem(title: dateButtonTitle, style: .plain, target: self, action: #selector(presentDatePicker))
        dateButton.setTitleTextAttributes([.font : UIFont(name: CustomFont.bold, size: 22)], for: .normal)
        dateButton.setTitleTextAttributes([.font : UIFont(name: CustomFont.bold, size: 22)], for: .highlighted)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = dateButton
        dateButton.tintColor = .black
        navigationController?.navigationBar.tintColor = .diaryColor
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        //FSCalendar
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
        //데이트피커
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        //추가버튼
        mainView.writingButton.addTarget(self, action: #selector(presentAddCalendarView), for: .touchUpInside)
    }
    
    private func setDatePickerSheet() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: "선택", style: .cancel) { _ in
            self.mainView.endEditing(true)
        }
        let contentViewController = UIViewController()
        contentViewController.view = datePicker
        contentViewController.preferredContentSize.height = 200
        
        alert.setValue(contentViewController, forKey: "contentViewController")
        alert.addAction(select)
        
        present(alert, animated: true)
    }

    //MARK: - @objc
    
    @objc private func presentAddCalendarView() {
        let vc = AddCalendarViewController()
        vc.currentStatus = CurrentStatus.new
        vc.selectedDate = selectDate.nearestHour()
        transition(vc, transitionStyle: .presentNavigationModally)
    }
    
    @objc private func reloadTableView(_ notification: NSNotification) {
        calendarTask = repository.fetchCalendar(date: selectDate)
        mainView.tableView.reloadData()
        mainView.calendar.reloadData()
    }

    @objc private func presentDatePicker(_ sender: UIButton) {
        setDatePickerSheet()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        print(sender.date)
        selectDate = sender.date
        mainView.calendar.select(selectDate, scrollToDate: true)
        calendarTask = repository.fetchCalendar(date: selectDate)
    }
    @objc private func setToday(_ sender: UIButton) {
        selectDate = Date().nearestHour()
        mainView.calendar.select(selectDate, scrollToDate: true)
        
        calendarTask = repository.fetchCalendar(date: selectDate)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = date.nearestHour()
        
        calendarTask = repository.fetchCalendar(date: date)
        
        if calendarTask.count == 0 {
            mainView.tableView.isHidden = true
            mainView.noTaskLabel.isHidden = false
        } else {
            mainView.tableView.isHidden = false
            mainView.noTaskLabel.isHidden = true
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        navigationItem.leftBarButtonItem?.title = calendar.currentPage.dateToString(type: .yearMonth)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if repository.fetchCalendar(date: date).count > 0 {
            return 1
        } else {
             return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.diaryColor]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.diaryColor]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if date == calendar.today {
            return .white
        } else {
            return .black
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarTask.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return selectDate.dateToString(type: .simple)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier) as? CalendarTableViewCell else { return UITableViewCell() }
        cell.colorView.backgroundColor = .setCustomColor(calendarTask[indexPath.row].color)
        cell.titleLabel.text = calendarTask[indexPath.row].title
        cell.dateLabel.text = calendarTask[indexPath.row].date.dateToString(type: .onlyTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editCalendarViewController = AddCalendarViewController()
        editCalendarViewController.task = calendarTask[indexPath.row]
        editCalendarViewController.selectedDate = calendarTask[indexPath.row].date
        editCalendarViewController.currentStatus = CurrentStatus.edit
        transition(editCalendarViewController, transitionStyle: .presentNavigationModally)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
