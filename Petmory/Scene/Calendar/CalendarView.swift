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
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 12
        view.backgroundColor = .yellow
        return view
    }()
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko-KR")
        
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
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [calendar, diaryButton].forEach {
            calendarView.addSubview($0)
        }
        [calendarView, tableView].forEach {
            self.addSubview($0)
        }
        backgroundColor = .white
    }
    
    override func setUpContraints() {
        super.setUpContraints()
        
        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.3)
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
    }
}
