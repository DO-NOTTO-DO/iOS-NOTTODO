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
    
    func getDailyMission(date: String) -> AnyPublisher<AchieveDetailData, Error> {
        missionAPI.getDailyMission(date: date)
            .map { data -> AchieveDetailData in
                return AchieveDetailData(missionList: data.data ?? [], selectedDate: date)
            }
            .eraseToAnyPublisher()
    }
}
