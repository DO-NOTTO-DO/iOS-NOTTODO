//
//  RecommendService.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/20.
//

import Foundation

import Moya

typealias RecommendData = GeneralArrayResponse<RecommendResponseDTO>
typealias ActionData = GeneralResponse<RecommendActionResponseDTO>
typealias SituationData = GeneralArrayResponse<RecommendSituationResponseDTO>

protocol RecommendServiceType {
    func getRecommend(completion: @escaping (RecommendData?) -> Void)
    func getRecommendAction(index: Int, completion: @escaping (ActionData?) -> Void)
    func getRecommendSituation(completion: @escaping (SituationData?) -> Void)
}

final class RecommendService: RecommendServiceType {
    
    static let shared: RecommendService = RecommendService()
    
    private let provider = MoyaProvider<RecommendAPI>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    private init() {}
        
    // MARK: - GET
    
    func getRecommend(completion: @escaping (RecommendData?) -> Void) {
        provider.request(.recommend) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendData?.self)
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
    
    func getRecommendAction(index: Int, completion: @escaping (GeneralResponse<RecommendActionResponseDTO>?) -> Void) {
        provider.request(.action(id: index)) { result in
            switch result {
            case .success(let response):
                do {
                    let reponse = try response.map(ActionData?.self)
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
    
    func getRecommendSituation(completion: @escaping (SituationData?) -> Void) {
        provider.request(.situdation) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try
                    response.map(SituationData?.self)
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
}
