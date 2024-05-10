//
//  TimeEntity.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 5/11/24.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    var date: Date = .now
    
    var dayOfWeek: String {
        return dateFormatterString(format: "E", date: date)
    }
    var todayMission: [DailyMissionResponseDTO]
    let quote: String
    
    private func dateFormatterString(format: String?, date: Date) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = format ?? "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: date)
        return convertStr
    }
}
