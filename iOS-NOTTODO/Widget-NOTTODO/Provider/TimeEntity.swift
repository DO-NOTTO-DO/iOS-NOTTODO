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
        return Formatter.dateFormatterString(format: "E", date: date)
    }
    var todayMission: [DailyMissionResponseDTO]
    let quote: String
}
