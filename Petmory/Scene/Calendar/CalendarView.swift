//
//  CalendarView.swift
//  Petmory
//
//  Created by HeecheolYoon on 2022/09/10.
//
import UIKit
import FSCalendar
import SnapKit

final class CalendarView: BaseView {
    
    let calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko-KR")
        
        //헤더 숨기기
        calendar.headerHeight = 0
        
        //폰트
        calendar.appearance.titleFont = UIFont(name: CustomFont.medium, size: 12)
        calendar.appearance.weekdayFont = UIFont(name: CustomFont.medium, size: 14)
        
        //컬러
        calendar.appearance.headerTitleColor = .diaryColor
        calendar.appearance.todayColor = .diaryColor
        calendar.appearance.selectionColor = .lightDiaryColor
        calendar.appearance.weekdayTextColor = .diaryColor
        calendar.appearance.titleSelectionColor = .black
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.todaySelectionColor = .diaryColor
        calendar.placeholderType = .fillHeadTail
        
        //날짜
        calendar.appearance.headerDateFormat = "yyyy. MM"
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        //세팅

        return calendar
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 13)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    let noTaskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 22)
        label.text = "일정 없음"
        label.textColor = .lightGray
        
        return label
    }()
    
    let writingButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: ImageName.plus)
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .stringColor
        configuration.baseBackgroundColor = .diaryColor
    
        button.configuration = configuration
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize.zero
        
        return button
    }()

    //헤더뷰
    let customTitleView: UIView = {
        let view = UIView()
        
        return view
    }()

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        datePicker.locale = Locale(identifier: "ko-KR")
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -50
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 30
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()

        calendarView.addSubview(calendar)
        [calendarView, noTaskLabel, tableView, dateLabel, writingButton].forEach {
            self.addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        noTaskLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
        writingButton.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
