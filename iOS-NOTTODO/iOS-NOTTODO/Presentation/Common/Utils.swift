//
//  Utils.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import Foundation

import FSCalendar

final class Utils {
    
    class func DateFormatter(format: String, date: Date) -> String? {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: date)
        return convertStr
    }
    
    class  func scrollCurrentPage(calendar: WeekMonthFSCalendar, isPrev: Bool) {
         let gregorian = Calendar(identifier: .gregorian)
        calendar.setCurrentPage( gregorian.date(byAdding: calendar.scope == .week ? .weekOfMonth : .month, value: isPrev ? -1 : 1, to: calendar.currentPage)!, animated: true)
    }
}
