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

final class CalendarViewController: BaseViewController {
    
    var mainView = CalendarView()
    
    var memories: Results<UserMemory>! {
        didSet {
            print("memories: \(memories)")
        }
    }
    
    var calendarTask: Results<UserCalendar>! {
        didSet {
            print(calendarTask)
            mainView.tableView.reloadData()
        }
    }
    
    var selectDate = Date()
    
    let repository = UserRepository()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarTask = repository.fetchCalendar(date: Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadTableView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mainView.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NotificationCenter.default.removeObserver(NSNotification(name: NSNotification.Name("reloadTableView"), object: nil))
    }
    
    override func setUpController() {
        super.setUpController()
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentAddCalendarView))
        navigationItem.rightBarButtonItem = addButton
        
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        //FSCalendar
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
    }
    
    //MARK: - @objc
    
    @objc private func presentAddCalendarView() {
        let vc = AddCalendarViewController()
        //vc.selectedDate = selectDate
        transition(AddCalendarViewController(), transitionStyle: .presentNavigationModally)
    }
    
    @objc private func reloadTableView(_ notification: NSNotification) {
        mainView.tableView.reloadData()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = date
        print(selectDate)
        
//        memories = repository.fetchDateFiltered(dateString: selectDate)
        calendarTask = repository.fetchCalendar(date: date)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier) as? CalendarTableViewCell else { return UITableViewCell() }
        cell.colorView.backgroundColor = .getCustomColor(calendarTask[indexPath.row].color)
        cell.titleLabel.text = calendarTask[indexPath.row].title
        cell.dateLabel.text = calendarTask[indexPath.row].date.dateToString(type: .onlyTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
