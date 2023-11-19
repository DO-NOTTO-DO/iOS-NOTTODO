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
    public private(set) var missionDetailDailyData: GeneralResponse<MissionDetailResponseDTO>?
    public private(set) var updateMissionStatus: GeneralResponse<DailyMissionResponseDTO>?
    public private(set) var missionWeekly: GeneralArrayResponse<WeekMissionResponseDTO>?
    public private(set) var addAnotherDay: GeneralResponse<AddAnotherDayResponseDTO>?
    public private(set) var particularDays: GeneralArrayResponse<String>?
    
    // MARK: - GET
    
    func getDailyMission(date: String, completion: @escaping (GeneralArrayResponse<DailyMissionResponseDTO>?) -> Void) {
        homeProvider.request(.dailyMission(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    self.missionDailyData = try response.map(GeneralArrayResponse<DailyMissionResponseDTO>?.self)
                    guard let missionDailtData = self.missionDailyData else { return }
                    completion(missionDailtData)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getWeeklyMissoin(startDate: String, completion: @escaping (GeneralArrayResponse<WeekMissionResponseDTO>?) -> Void) {
        homeProvider.request(.missionWeekly(startDate: startDate)) { result in
            switch result {
            case .success(let response):
                do {
                    self.missionWeekly = try response.map(GeneralArrayResponse<WeekMissionResponseDTO>?.self)
                    guard let missionWeekly = self.missionWeekly else { return }
                    completion(missionWeekly)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getDailyDetailMission(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        homeProvider.request(.dailyDetailMission(id: id)) { response in
            switch response {
            case let .success(response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = NetworkBase.judgeStatus(by: statusCode, data, MissionDetailResponseDTO.self)
                completion(networkResult)
            case let .failure(err):
                print(err)
            }
        }
    }
    
    func particularMissionDates(id: Int, completion: @escaping (GeneralArrayResponse<String>) -> Void) {
        homeProvider.request(.particularMission(id: id)) { response in
            switch response {
            case let .success(response):
                do {
                    self.particularDays = try response.map(GeneralArrayResponse<String>.self)
                    guard self.particularDays != nil else { return }
                    completion((self.particularDays)!)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case let .failure(err):
                print(err)
            }
        }
    }
    
    // MARK: - Delete
    
    func deleteMission(id: Int, completion: @escaping (GeneralResponse<VoidType>?) -> Void) {
        homeProvider.request(.deleteMission(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.map(GeneralResponse<VoidType>.self)
                    completion(data)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    // MARK: - Patch
    
    func patchUpdateMissionStatus(id: Int, status: String, completion: @escaping (GeneralResponse<DailyMissionResponseDTO>?) -> Void) {
        homeProvider.request(.updateMissionStatus(id: id, status: status)) { result in
            switch result {
            case .success(let response):
                do {
                    self.updateMissionStatus = try response.map(GeneralResponse<DailyMissionResponseDTO>?.self)
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
    
    // MARK: - Post
    
    func postAnotherDay(id: Int, dates: [String], completion: @escaping (GeneralResponse<AddAnotherDayResponseDTO>?) -> Void) {
        homeProvider.request(.addAnotherDay(id: id, dates: dates)) { result in
            switch result {
            case .success(let response):
                do {
                    self.addAnotherDay = try response.map(GeneralResponse<AddAnotherDayResponseDTO>?.self)
                    guard let addAnotherDay = self.addAnotherDay else { return }
                    completion(addAnotherDay)
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
