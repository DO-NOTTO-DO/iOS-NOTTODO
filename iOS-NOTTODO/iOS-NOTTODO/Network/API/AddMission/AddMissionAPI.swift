//
//  AddMissionAPI.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/07.
//

import Foundation

import Moya

final class AddMissionAPI {
    
    static let shared: AddMissionAPI = AddMissionAPI()
    
    private let addMissionProvider = MoyaProvider<AddMissionService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var recommendSituationData: GeneralArrayResponse<RecommendSituationResponseDTO>?
    public private(set) var addMissionData: GeneralResponse<AddMissionResponseDTO>?
    public private(set) var updateMissionData: GeneralResponse<UpdateMissionResponseDTO>?
    public private(set) var recentMissionData: GeneralArrayResponse<RecentMissionResponseDTO>?
    public private(set) var missionDatesData: GeneralArrayResponse<String>?
    
    // MARK: - GET
    
    func getRecommendSituation(completion: @escaping (GeneralArrayResponse<RecommendSituationResponseDTO>?) -> Void) {
        addMissionProvider.request(.recommendSituation) { result in
            switch result {
            case .success(let response):
                do {
                    self.recommendSituationData = try
                    response.map(GeneralArrayResponse<RecommendSituationResponseDTO>?.self)
                    guard let recommendSituationData = self.recommendSituationData else { return }
                    completion(recommendSituationData)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getRecentMission(completion: @escaping (GeneralArrayResponse<RecentMissionResponseDTO>?) -> Void) {
        addMissionProvider.request(.recentMission) { result in
            switch result {
            case .success(let response):
                do {
                    self.recentMissionData = try response.map(GeneralArrayResponse<RecentMissionResponseDTO>?.self)
                    guard let recentMissionData = self.recentMissionData else { return }
                    completion(recentMissionData)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func getMissionDates(id: Int, completion: @escaping (GeneralArrayResponse<String>?) -> Void) {
        addMissionProvider.request(.missionDates(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    self.missionDatesData = try response.map(GeneralArrayResponse<String>?.self)
                    guard let missionDatesData = self.missionDatesData else { return }
                    completion(missionDatesData)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    // MARK: - POST
    
    func postAddMission(title: String, situation: String, actions: [String]?,
                        goal: String?, dates: [String],
                        completion: @escaping(GeneralResponse<AddMissionResponseDTO>?) -> Void) {
        addMissionProvider.request(.addMission(title: title, situation: situation, actions: actions, goal: goal, dates: dates)) { result in
            switch result {
            case .success(let response):
                do {
                    self.addMissionData = try response.map(GeneralResponse<AddMissionResponseDTO>?.self)
                    guard let addMission = self.addMissionData else { return }
                    completion(addMission)
                } catch let err {
                    print(err.localizedDescription, 500)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
            }
        }
    }
    
    // MARK: PUT
    
    func putUpdateMission(id: Int, title: String, situation: String, actions: [String]?, goal: String?, completion: @escaping(GeneralResponse<UpdateMissionResponseDTO>?) -> Void) {
        addMissionProvider.request(.updateMission(id: id, title: title, situation: situation, actions: actions, goal: goal)) { result in
            switch result {
            case .success(let response):
                do {
                    self.updateMissionData = try response.map(GeneralResponse<UpdateMissionResponseDTO>?.self)
                    guard let updateMission = self.updateMissionData else { return }
                    completion(updateMission)
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
