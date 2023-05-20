//
//  HomeAPI.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/20.
//

import Foundation

import Moya

final class HomeAPI {
    
    static let shared: HomeAPI = HomeAPI()
    
    var homeProvider = MoyaProvider<HomeService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var missionDailyData: GeneralArrayResponse<DailyMissionResponseDTO>?
    
    // MARK: - GET
    
    func getDailyMission(date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.dailyMission(date: date)) { response in
            switch response {
            case let .success(response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, [DailyMissionResponseDTO].self)
                completion(networkResult)
            case let .failure(err):
                print(err)
            }
        }
    }
    
    func getWeeklyMissoin(startDate: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.missionWeekly(startDate: startDate)) { response in
            switch response {
            case let .success(response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data,
                                                            [WeekMissionResponseDTO].self)
                completion(networkResult)
            case let .failure(err):
                print(err)
            }
        }
    }
}
