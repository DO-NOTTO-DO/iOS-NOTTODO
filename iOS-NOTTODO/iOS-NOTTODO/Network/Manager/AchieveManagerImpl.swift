//
//  AchieveManagerImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

final class AchieveManagerImpl: AchieveManager {
    
    private let missionAPI: DefaultMissionAPI
    private let cancelBag = Set<AnyCancellable>()
    
    init(missionAPI: DefaultMissionAPI) {
        self.missionAPI = missionAPI
    }

    func getDailyMission(date: String) -> AnyPublisher<[AchieveDetailData], Error> {
        missionAPI.getDailyMission(date: date)
            .map { $0.data?.map { $0.toData(selectedDate: date) } ?? [] }
            .eraseToAnyPublisher()
    }
    
    func getAchieveCalendar(month: Date) -> AnyPublisher<CalendarEventData, Error> {
        return missionAPI.getAchieveCalendar(month: month.formattedString(format: "yyyy-MM"))
    //        .map { $0.data?.map { $0.toData(month: month) }  ?? [}
            .map { response in
                self.convertResponseToCalendarEventData(response, month: month)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private func convertResponseToCalendarEventData(_ response: CalendarData, month: Date) -> CalendarEventData? {
        guard let data = response.data else { return nil }
        let calendarData = Dictionary(uniqueKeysWithValues: data.map { ($0.actionDate, $0.percentage) })
        return CalendarEventData(month: month, percentages: calendarData)
    }
}
