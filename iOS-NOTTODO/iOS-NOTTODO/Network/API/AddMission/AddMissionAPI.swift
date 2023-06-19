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
    
    private let addMissionProvider = MoyaProvider<AddMissionService>(plugins: [NetworkLoggerPlugin()])
    
    private init() { }
    
    public private(set) var recommendSituationData: GeneralArrayResponse<RecommendSituationResponseDTO>?
    public private(set) var addMissionData: GeneralResponse<AddMissionResponseDTO>?
    
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
}
