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
    
    let titleViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 18)
        label.textAlignment = .center
        label.tintColor = .clear
        label.sizeToFit()
        label.text = "123123123"
        
        return label
    }()
    
    let titleViewRightButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.baseForegroundColor = .diaryColor
        
        button.configuration = configuration
        return button
    }()
    let titleViewLeftButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.left")
        configuration.baseForegroundColor = .diaryColor
        
        button.configuration = configuration
        return button
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        [titleViewLeftButton, titleViewRightButton, titleViewLabel].forEach {
            customTitleView.addSubview($0)
        }
        
        titleViewLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        titleViewLeftButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleViewLabel)
            make.leading.equalToSuperview()
            make.trailing.equalTo(titleViewLabel.snp.left).offset(-8)
        }
        titleViewRightButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleViewLabel)
            make.trailing.equalToSuperview()
            make.leading.equalTo(titleViewLabel.snp.left).offset(-8)
        }
    }
    
    override func setUpController() {
        super.setUpController()
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentAddCalendarView))
        navigationItem.rightBarButtonItem = addButton
        
        navigationController?.navigationBar.tintColor = .diaryColor
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        //FSCalendar
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
        //타이틀뷰
        navigationItem.titleView = customTitleView
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
