//
//  WeekMonthCalendar.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import UIKit

import FSCalendar

final class WeekMonthCalendar: FSCalendar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(calendarScope : FSCalendarScope, scrollDirection : FSCalendarScrollDirection){
        super.init(frame: .zero)
        self.scope =  calendarScope
        self.scrollDirection =  scrollDirection
        configure(scope: calendarScope)
        weekdayTitleStyle(scope: calendarScope)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(scope: FSCalendarScope) {
        calendarHeaderView.isHidden = true
        headerHeight = 0
        backgroundColor = .clear
        
        // title
        appearance.titleDefaultColor = .white
        appearance.titleSelectionColor = .white //선택한 날짜 글자 색상
        // subtitle
        appearance.subtitleSelectionColor = .white
        appearance.subtitleDefaultColor = .white

        appearance.todayColor = .clear
        appearance.selectionColor = .clear //선택한 날짜 동그라미 색상
        appearance.borderDefaultColor = .clear
        
        switch scope {
        case .week:
            calendarWeekdayView.removeFromSuperview()
            appearance.borderSelectionColor = .white
            appearance.subtitleOffset = CGPoint(x: 0, y: 10)
        case .month:
            allowsMultipleSelection = true
            appearance.borderSelectionColor = .clear
            appearance.weekdayTextColor = .white
            appearance.selectionColor = .lightGray
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
