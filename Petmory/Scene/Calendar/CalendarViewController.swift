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
    
    var selectDate = ""
    
    let repository = UserRepository()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @objc private func presentAddCalendarView() {
        
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = date.dateToString()
        print(selectDate)
        print(monthPosition)
        memories = repository.fetchDateFiltered(dateString: selectDate)
        print(memories.count)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier) as? CalendarTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
