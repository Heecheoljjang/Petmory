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
        calendar.appearance.headerTitleFont = UIFont(name: CustomFont.medium, size: 20)
        
        //컬러
        calendar.appearance.headerTitleColor = .diaryColor
        calendar.appearance.todayColor = .diaryColor
        calendar.appearance.selectionColor = .lightDiaryColor
        calendar.appearance.weekdayTextColor = .diaryColor
        calendar.appearance.titleSelectionColor = .black
        calendar.appearance.titleTodayColor = .white
        
        //날짜
        calendar.appearance.headerDateFormat = "yyyy. MM"
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0

        return calendar
    }()
    
    let diaryButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.title = "작성한 기록 보러가기"
        configuration.imagePlacement = .trailing
        
        button.configuration = configuration
        return button
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        view.separatorStyle = .none
        return view
    }()
    
    let noTaskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 22)
        label.text = "일정 없음"
        label.textColor = .lightGray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
    
        [calendar, diaryButton].forEach {
            calendarView.addSubview($0)
        }
        [calendarView, noTaskLabel, tableView].forEach {
            self.addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        diaryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(diaryButton.snp.top)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        noTaskLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }
}
