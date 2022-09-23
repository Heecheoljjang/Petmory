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
    
    var selectDate = Date()
    
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

    //datePicker
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = Locale(identifier: "ko-KR")
        picker.datePickerMode = .date
        picker.backgroundColor = .white
        picker.tintColor = .white
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    lazy var datePickerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.width * 0.6))
        view.backgroundColor = .white
        
        return view
    }()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateButtonTitle = selectDate.dateToString(type: .yearMonth)
        
        calendarTask = repository.fetchCalendar(date: Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_ :)), name: NSNotification.Name.doneButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_ :)), name: NSNotification.Name.deleteButton, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mainView.tableView.reloadData()
    }

    override func configure() {
        super.configure()
        
        datePickerView.addSubview(datePicker)
        
    }
    
    override func setUpController() {
        super.setUpController()
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentAddCalendarView))
        let dateButton = UIBarButtonItem(title: dateButtonTitle, style: .plain, target: self, action: #selector(presentDatePicker))
        dateButton.setTitleTextAttributes([.font : UIFont(name: CustomFont.bold, size: 20)], for: .normal)
        dateButton.setTitleTextAttributes([.font : UIFont(name: CustomFont.bold, size: 20)], for: .highlighted)
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = dateButton
        dateButton.tintColor = .black
        navigationController?.navigationBar.tintColor = .diaryColor
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        //FSCalendar
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
        //타이틀뷰
        //navigationItem.titleView = customTitleView
    }
    
    private func setDatePickerSheet() {
        let alert = UIAlertController(title: "날짜를 선택해주세요", message: nil, preferredStyle: .actionSheet)
        let select = UIAlertAction(title: "선택", style: .cancel) { _ in
            self.mainView.endEditing(true)
        }
        alert.view.addSubview(datePickerView)
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
        //datePicker띄우기
        setDatePickerSheet()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = date.nearestHour()
        print("calendarDate: \(selectDate)")
        
//        memories = repository.fetchDateFiltered(dateString: selectDate)
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
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarTask.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectDate.dateToString(type: .simple)
    }
    
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
