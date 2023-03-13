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

final class CalendarView: UIView {
    
    // MARK: - UI Components
    
    let yearMonthLabel = UILabel()
    let todayButton = UIButton(configuration: .filled())
    let horizonStackView = UIStackView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    var calendar = WeekMonthFSCalendar()
    private lazy var today: Date = { return Date() }()

    // MARK: - Life Cycle
    
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

// MARK: - Methods

extension CalendarView {
    
    private func setCalendar(scope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        calendar = WeekMonthFSCalendar(calendarScope: scope, scrollDirection: scrollDirection)
    }
    
    private func setUI() {
        backgroundColor = .ntdBlack
        
        yearMonthLabel.do {
            $0.font = .Pretendard(.medium, size: 18)
            $0.textColor = .white
            $0.text = Utils.DateFormatter(format: I18N.yearMonthTitle, date: Date())
        }
        todayButton.do {
            $0.configuration?.image = .icBackToday
            $0.configuration?.title = I18N.todayButton
            $0.configuration?.imagePadding = 2
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 3, leading: 6, bottom: 2, trailing: 7)
            $0.configuration?.cornerStyle = .capsule
            $0.configuration?.attributedTitle?.font = .Pretendard(.regular, size: 14)
            $0.configuration?.baseBackgroundColor = .gray2
            $0.configuration?.baseForegroundColor = .gray5
            $0.addTarget(self, action: #selector(todayBtnTapped), for: .touchUpInside)
        }
        horizonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        leftButton.do {
            $0.setImage(.calendarLeft, for: .normal)
            $0.addTarget(self, action: #selector(prevBtnTapped), for: .touchUpInside)
        }
        rightButton.do {
            $0.setImage(.calendarRight, for: .normal)
            $0.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
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
                $0.top.equalTo(yearMonthLabel.snp.top)
                $0.trailing.equalToSuperview().inset(18)
                $0.size.equalTo(CGSize(width: 60, height: 30))
            }
            
            calendar.snp.makeConstraints {
                $0.top.equalTo(yearMonthLabel.snp.bottom).offset(8)
                $0.directionalHorizontalEdges.equalToSuperview().inset(11)
                $0.bottom.equalToSuperview().inset(20)
            }
            
        case .month:
            addSubviews(horizonStackView, calendar)
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
                $0.height.equalTo(25)
            }
            
            calendar.snp.makeConstraints {
                $0.top.equalTo(horizonStackView.snp.bottom).offset(20)
                $0.directionalHorizontalEdges.equalToSuperview().inset(15)
                $0.bottom.equalToSuperview().inset(25)
            }
        @unknown default:
            return
        }
    }
    
    @objc
    func todayBtnTapped(_sender: UIButton) {
        calendar.select(today)
        yearMonthLabel.text = Utils.DateFormatter(format: I18N.yearMonthTitle, date: today)
    }
    
    @objc
    func prevBtnTapped(_sender: UIButton) {
        Utils.scrollCurrentPage(calendar: calendar, isPrev: true)
    }
    
    @objc
    func nextBtnTapped(_sender: UIButton) {
        Utils.scrollCurrentPage(calendar: calendar, isPrev: false)
    }
}
