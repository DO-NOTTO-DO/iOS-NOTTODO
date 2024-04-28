//
//  MissionService.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/20.
//

import Foundation
import Combine

import Moya

// 전체 수정 후 - 네이밍 변경 MissionAPI
protocol MissionServiceProtocol {
    func getDailyMission(date: String) -> AnyPublisher<DailyMissionData, Error>
    func getAchieveCalendar(month: String) -> AnyPublisher<CalendarData, Error>
}

typealias DefaultMissionService = BaseService<MissionAPI>

extension DefaultMissionService: MissionServiceProtocol {
    
    func getDailyMission(date: String) -> AnyPublisher<DailyMissionData, Error> {
        return requestWithCombine(MissionAPI.dailyMission(date: date))
    }
    
    func getAchieveCalendar(month: String) -> AnyPublisher<CalendarData, Error> {
        return requestWithCombine(MissionAPI.achieveCalendar(month: month))
    }
}

typealias DailyMissionData = GeneralArrayResponse<DailyMissionResponseDTO>
typealias DetailMissionData = GeneralResponse<MissionDetailResponseDTO>
typealias CalendarData = GeneralArrayResponse<CalendarReponseDTO>
typealias RecentMissionData = GeneralArrayResponse<RecentMissionResponseDTO>
typealias UpdateMissionData = GeneralResponse<UpdateMissionResponseDTO>
typealias AddMissionsData = GeneralResponse<AddMissionResponseDTO>
typealias AddAnotherDay = GeneralResponse<AddAnotherDayResponseDTO>
typealias UpdateMissionStatus = GeneralResponse<DailyMissionResponseDTO>

protocol MissionServiceType {
    func getDailyMission(date: String, completion: @escaping (DailyMissionData?) -> Void)
    func getWeeklyMissoin(startDate: String, completion: @escaping (CalendarData?) -> Void)
    func getDetailMission(id: Int, completion: @escaping (DetailMissionData?) -> Void)
    func particularMissionDates(id: Int, completion: @escaping (GeneralArrayResponse<String>) -> Void)
    func getAchieveCalendar(month: String, completion: @escaping (CalendarData?) -> Void)
    func getRecentMission(completion: @escaping (RecentMissionData?) -> Void)
    func deleteMission(id: Int, completion: @escaping (GeneralResponse<VoidType>?) -> Void)
    func patchUpdateMissionStatus(id: Int, status: String, completion: @escaping (UpdateMissionStatus?) -> Void)
    func postAnotherDay(id: Int, dates: [String], completion: @escaping (ErrorResponse?) -> Void)
    func postAddMission(request: AddMissionRequest, completion: @escaping(ErrorResponse?) -> Void)
    func putUpdateMission(request: UpdateMissionRequest, completion: @escaping(ErrorResponse?) -> Void)
}

final class MissionService: MissionServiceType {
    
    static let shared: MissionService = MissionService()
    
    var provider = MoyaProvider<MissionAPI>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    private init() {}
    
    func getDailyMission(date: String, completion: @escaping (DailyMissionData?) -> Void) {
        provider.request(.dailyMission(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    let reponse = try response.map(DailyMissionData?.self)
                    completion(reponse)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getWeeklyMissoin(startDate: String, completion: @escaping (CalendarData?) -> Void) {
        provider.request(.missionWeekly(startDate: startDate)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(CalendarData?.self)
                    completion(response)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getDetailMission(id: Int, completion: @escaping (DetailMissionData?) -> Void) {
        provider.request(.detailMission(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(DetailMissionData?.self)
                    
                    completion(response)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getAchieveCalendar(month: String, completion: @escaping (CalendarData?) -> Void) {
        provider.request(.achieveCalendar(month: month)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(CalendarData?.self)
                    completion(response)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getRecentMission(completion: @escaping (RecentMissionData?) -> Void) {
        provider.request(.recentMission) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecentMissionData?.self)
                    completion(response)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func particularMissionDates(id: Int, completion: @escaping (GeneralArrayResponse<String>) -> Void) {
        provider.request(.particularMission(id: id)) { response in
            switch response {
            case let .success(response):
                do {
                    let response = try response.map(GeneralArrayResponse<String>.self)
                    completion(response)
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
        provider.request(.deleteMission(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(GeneralResponse<VoidType>.self)
                    completion(response)
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
    
    func patchUpdateMissionStatus(id: Int, status: String, completion: @escaping (UpdateMissionStatus?) -> Void) {
        provider.request(.updateMissionStatus(id: id, status: status)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(UpdateMissionStatus?.self)
                    completion(response)
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
    
    func postAnotherDay(id: Int, dates: [String], completion: @escaping (ErrorResponse?) -> Void) {
        provider.request(.addAnotherDay(id: id, dates: dates)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(AddAnotherDay?.self)
                    completion(nil)
                } catch let err {
                    print(err.localizedDescription, 500)
                    completion(nil)
                }
            case .failure(let err):
                if let response = err.response {
                    do {
                        let errorResponse = try response.map(ErrorResponse.self)
                        print("💎 Server Error 💎: \(errorResponse.message)")
                        completion(errorResponse)
                    } catch {
                        print("💎 Mapping Error 💎: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("💎 Network Error 💎: \(err.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    func postAddMission(request: AddMissionRequest,
                        completion: @escaping(ErrorResponse?) -> Void) {
        provider.request(.addMission(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(AddMissionsData?.self)
                    completion(nil)
                } catch let err {
                    print(err.localizedDescription, 500)
                    completion(nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                if let response = err.response {
                    do {
                        let errorResponse = try response.map(ErrorResponse.self)
                        print("💎 Server Error 💎: \(errorResponse.message)")
                        completion(errorResponse)
                    } catch {
                        print("💎 Mapping Error 💎: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("💎 Network Error 💎: \(err.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: PUT
    
    func putUpdateMission(request: UpdateMissionRequest, completion: @escaping(ErrorResponse?) -> Void) {
        provider.request(.updateMission(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(UpdateMissionData?.self)
                    completion(nil)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                if let response = err.response {
                    do {
                        let errorResponse = try response.map(ErrorResponse.self)
                        print("💎 Server Error 💎: \(errorResponse.message)")
                        completion(errorResponse)
                    } catch {
                        print("💎 Mapping Error 💎: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("💎 Network Error 💎: \(err.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
}
