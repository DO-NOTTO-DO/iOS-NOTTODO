//
//  AchieveManager.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

protocol AchieveManager {
    func getDailyMission(date: String) -> AnyPublisher<[AchieveDetailData], Error>
    func getAchieveCalendar(month: Date) -> AnyPublisher<CalendarEventData, Error>
}
