//
//  Utils.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import Foundation

import FSCalendar

final class Utils {
    
    class func DateFormatterString(format: String, date: Date) -> String? {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: date)
        return convertStr
    }
    
    class func scrollCurrentPage(calendar: WeekMonthFSCalendar, isPrev: Bool) {
        let gregorian = Calendar(identifier: .gregorian)
        calendar.setCurrentPage( gregorian.date(byAdding: calendar.scope == .week ? .weekOfMonth : .month, value: isPrev ? -1 : 1, to: calendar.currentPage)!, animated: true)
    }
    
    class func calendarTitleColor(today: Date, date: Date, selected: Bool) -> UIColor? {
        switch Calendar.current.compare(today, to: date, toGranularity: .day) {
        case .orderedSame:
            print("\(date) is the same as \(today)")
            return selected ? .black : .white
        case .orderedDescending:
            print("\(date) is before \(today)")
            return  .gray3
        case .orderedAscending:
            print("\(date) is after \(today)")
            let sevenDays = Calendar.current.date(byAdding: .day, value: +6, to: Date())!
            if date < sevenDays {
                return selected ? .black : .white
            }
            return .gray3
        }
    }
}
