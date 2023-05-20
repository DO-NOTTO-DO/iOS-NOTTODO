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
    public private(set) var updateMissionStatus: GeneralResponse<UpdateMissionResponseDTO>?
    public private(set) var missionWeekly: GeneralResponse<WeekMissionResponseDTO>?

    
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
    
    // MARK: - Patch
    
    func patchUpdateMissionStatus(id: Int, status: String, completion: @escaping (GeneralResponse<UpdateMissionResponseDTO>?) -> Void) {
        homeProvider.request(.updateMissionStatus(id: id, status: status)) { result in
            switch result {
            case .success(let response):
                do {
                    self.updateMissionStatus = try response.map(GeneralResponse<UpdateMissionResponseDTO>?.self)
                    guard self.updateMissionStatus != nil else { return }
                    completion(self.updateMissionStatus)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
}
