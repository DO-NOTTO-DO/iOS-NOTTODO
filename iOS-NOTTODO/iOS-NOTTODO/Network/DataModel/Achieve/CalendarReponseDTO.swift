//
//  AchieveCalendarResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/18.
//

import Foundation

struct CalendarReponseDTO: Codable {
    let actionDate: String
    let percentage: Float
    
    func toDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
    func convert() -> [Date: Float] {
        guard let date = self.toDate(dateString: actionDate) else { return [:]}
        return [date: percentage]
    }
}

extension Array where Element == CalendarReponseDTO {
    
    func toData(month: Date) -> CalendarEventData {
        let calendarData = Dictionary(uniqueKeysWithValues: self.map { ($0.actionDate, $0.percentage) })
        return CalendarEventData(month: month, percentages: calendarData)
    }
}
