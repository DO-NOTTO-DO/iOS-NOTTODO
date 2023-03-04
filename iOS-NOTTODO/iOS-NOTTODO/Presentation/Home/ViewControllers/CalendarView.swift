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

class CustomCalendarView: UIView {
    
    let yearMonthLabel = UILabel()
    let todayButton = UIButton()
    let horizonStackView = UIStackView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    let dateFormatter = DateFormatter()
    var calendar = WeekMonthCalendar()
    
    init(calendarScope : FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        super.init(frame: .zero)
        setCalendar(scope: calendarScope, scrollDirection: scrollDirection)
        setUI()
        setLayout(scope: calendarScope)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CustomCalendarView {
    
    private func setCalendar(scope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        calendar = WeekMonthCalendar(calendarScope: scope, scrollDirection: scrollDirection)
    }
    
    private func setUI() {
        backgroundColor = .black
        
        dateFormatter.do {
            $0.locale = Locale(identifier: "ko_KR")
            $0.dateFormat = "YYYY년 MM월"
            $0.timeZone = TimeZone(identifier: "KST")
        }
        yearMonthLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .white
        }
        todayButton.do {
            $0.setTitle("TODAY", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16)
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
            addSubviews(yearMonthLabel,todayButton,calendar)
            
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
                $0.top.equalTo(yearMonthLabel.snp.bottom).offset(26)
                $0.centerX.equalToSuperview()
                $0.directionalHorizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        case .month:
            addSubviews(yearMonthLabel,horizonStackView)
            horizonStackView.addArrangedSubviews(leftButton, yearMonthLabel, rightButton)
                        
            leftButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            rightButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            horizonStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(25)
                $0.centerX.equalToSuperview()
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
