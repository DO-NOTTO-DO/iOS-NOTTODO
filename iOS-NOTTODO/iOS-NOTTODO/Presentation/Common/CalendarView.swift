//
//  CalendarView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import UIKit

import FSCalendar
import Then
import SnapKit

class CalendarView: UIView {
    
    let yearMonthLabel = UILabel()
    let todayButton = UIButton()
    let horizonStackView = UIStackView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    var calendar = WeekMonthFSCalendar()
    
    init(calendarScope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        super.init(frame: .zero)
        setCalendar(scope: calendarScope, scrollDirection: scrollDirection)
        setUI()
        setLayout(scope: calendarScope)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CalendarView {
    
    private func setCalendar(scope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        calendar = WeekMonthFSCalendar(calendarScope: scope, scrollDirection: scrollDirection)
    }
    
    private func setUI() {
        backgroundColor = .ntdBlack
        
        yearMonthLabel.do {
            $0.font = .Pretendard(.medium, size: 18)
            $0.textColor = .white
            $0.text = Utils.DateFormatter(format: "YYYY년 MM월", date: Date())
        }
        todayButton.do {
            $0.setTitle("TODAY", for: .normal)
            $0.layer.backgroundColor = UIColor.gray2?.cgColor
            $0.setTitleColor(.gray5, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 14)
        }
        horizonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        leftButton.do {
            $0.setImage(.calendarLeft, for: .normal)
        }
        rightButton.do {
            $0.setImage(.calendarRight, for: .normal)
        }
    }
    private func setLayout(scope: FSCalendarScope) {
        switch scope {
        case .week:
            addSubviews(calendar, yearMonthLabel, todayButton)
            
            yearMonthLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(23)
                $0.leading.equalToSuperview().offset(20)
            }
            
            todayButton.snp.makeConstraints {
                $0.top.equalTo(yearMonthLabel.snp.top).offset(1)
                $0.trailing.equalToSuperview().inset(18)
                $0.size.equalTo(CGSize(width: 60, height: 22))
            }
            
            calendar.snp.makeConstraints {
                $0.top.equalTo(yearMonthLabel.snp.bottom).offset(8)
                $0.directionalHorizontalEdges.equalToSuperview().inset(11)
                $0.bottom.equalToSuperview()
            }

        case .month:
            addSubviews(yearMonthLabel, horizonStackView)
            
            horizonStackView.addArrangedSubviews(leftButton, yearMonthLabel, rightButton)
            
            leftButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            rightButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            horizonStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(25)
                $0.directionalHorizontalEdges.equalToSuperview().inset(82)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(25)
            }
            
            calendar.snp.makeConstraints {
                $0.top.equalTo(leftButton.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.directionalHorizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        @unknown default:
            return
        }
    }
}
