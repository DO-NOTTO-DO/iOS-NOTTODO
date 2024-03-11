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
    
    init(calendarScope: FSCalendarScope) {
        super.init(frame: .zero)
        self.scope =  calendarScope
        
        setUI()
        configure(scope: calendarScope)
        weekdayTitleStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension WeekMonthFSCalendar {
    
    func setUI() {
       
        locale = Locale(identifier: "ko_KR")
        calendarHeaderView.isHidden = true
        headerHeight = 0
        backgroundColor = .clear
        scrollDirection = .horizontal
        
        appearance.titleDefaultColor = .white
        appearance.titleFont = .Pretendard(.medium, size: 14)
        
        appearance.subtitleSelectionColor = .white
        appearance.subtitleDefaultColor = .white
        appearance.subtitleFont = .Pretendard(.medium, size: 14)
        
        appearance.todayColor = .clear
        appearance.selectionColor = .clear
        appearance.borderDefaultColor = .clear
    }
    
    func configure(scope: FSCalendarScope) {

        switch scope {
        case .week:
            calendarWeekdayView.removeFromSuperview()
            appearance.borderSelectionColor = .white
            appearance.titleSelectionColor = .white
        case .month:
            allowsMultipleSelection = true
            appearance.borderSelectionColor = .clear
            appearance.weekdayTextColor = .gray4
            appearance.selectionColor = .white
            appearance.titleSelectionColor = .ntdBlack
            placeholderType = .fillHeadTail
        @unknown default:
            return
        }
    }
    
    func weekdayTitleStyle() {
        guard self.scope == .month else { return }
        
        I18N.weekDay.enumerated().forEach { index, day in
            calendarWeekdayView.weekdayLabels[index].text = day
        }
        appearance.headerMinimumDissolvedAlpha = 0
        
    }
}
