//
//  AchieveAPI.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/18.
//

import Foundation

import Moya

final class AchieveAPI {
    
    static let shared: AchieveAPI = AchieveAPI()
    
    private let achieveProvider = MoyaProvider<AchieveService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var missionDetailData: GeneralResponse<MissionDetailResponseDTO>?
    public private(set) var achieveCalendarData: GeneralArrayResponse<AchieveCalendarResponseDTO>?
    
    // MARK: - GET
    
    func getMissionDetail(missionId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        achieveProvider.request(.achieveDetail(missionId: missionId)) { response in
            switch response {
            case let .success(response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data,
                                                            [MissionDetailResponseDTO].self)
                completion(networkResult)
            case let .failure(err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - GET
    
    func getAchieveCalendar(month: String, completion: @escaping (GeneralArrayResponse<AchieveCalendarResponseDTO>?) -> Void) {
        achieveProvider.request(.achieveCalendar(month: month)) { result in
            switch result {
            case .success(let response):
                do {
                    self.achieveCalendarData = try response.map(GeneralArrayResponse<AchieveCalendarResponseDTO>?.self)
                    guard let achieveCalendarData = self.achieveCalendarData else { return completion(nil) }
                    completion(achieveCalendarData)
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
