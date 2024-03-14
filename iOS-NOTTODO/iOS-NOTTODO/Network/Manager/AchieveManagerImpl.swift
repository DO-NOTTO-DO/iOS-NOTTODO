//
//  AchieveManagerImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

final class AchieveManagerImpl: AchieveManager {
    
    private let missionAPI: MissionServiceProtocol
    private let cancelBag = Set<AnyCancellable>()
    
    init(missionAPI: MissionServiceProtocol) {
        self.missionAPI = missionAPI
    }
    
    func getDailyMission(date: String) -> AnyPublisher<[AchieveDetailData], Error> {
        missionAPI.getDailyMission(date: date)
            .map { $0.data?.map { $0.toData(selectedDate: date) } }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getAchieveCalendar(month: Date) -> AnyPublisher<CalendarEventData, Error> {
        return missionAPI.getAchieveCalendar(month: month.formattedString(format: "yyyy-MM"))
            .map { $0.data?.toData(month: month) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
