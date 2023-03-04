//
//  WeekMonthCalendar.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import UIKit

import FSCalendar

final class WeekMonthFSCalendar: FSCalendar {
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(calendarScope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        super.init(frame: .zero)
        self.scope =  calendarScope
        self.scrollDirection =  scrollDirection
        configure(scope: calendarScope)
        weekdayTitleStyle(scope: calendarScope)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension WeekMonthFSCalendar {
    func configure(scope: FSCalendarScope) {
        calendarHeaderView.isHidden = true
        headerHeight = 0
        backgroundColor = .clear
        
        appearance.titleDefaultColor = .white
        appearance.titleFont = .Pretendard(.medium, size: 14)
        
        appearance.subtitleSelectionColor = .white
        appearance.subtitleDefaultColor = .white
        appearance.subtitleFont = .Pretendard(.medium, size: 14)

        appearance.todayColor = .clear
        appearance.selectionColor = .clear
        appearance.borderDefaultColor = .clear
        
        switch scope {
        case .week:
            calendarWeekdayView.removeFromSuperview()
            appearance.borderSelectionColor = .white
            appearance.titleSelectionColor = .white
            appearance.subtitleOffset = CGPoint(x: 0, y: 20)
        case .month:
            allowsMultipleSelection = true
            appearance.borderSelectionColor = .clear
            appearance.weekdayTextColor = .white
            appearance.selectionColor = .white
            appearance.titleSelectionColor = .ntdBlack
        @unknown default:
            return
        }
    }
    
    func weekdayTitleStyle(scope: FSCalendarScope) {
        switch self.scope {
        case .week:
            return
        case .month:
            calendarWeekdayView.weekdayLabels[0].text = "일"
            calendarWeekdayView.weekdayLabels[1].text = "월"
            calendarWeekdayView.weekdayLabels[2].text = "화"
            calendarWeekdayView.weekdayLabels[3].text = "수"
            calendarWeekdayView.weekdayLabels[4].text = "목"
            calendarWeekdayView.weekdayLabels[5].text = "금"
            calendarWeekdayView.weekdayLabels[6].text = "토"
            appearance.headerMinimumDissolvedAlpha = 0
        @unknown default:
            return
        }
    }
}