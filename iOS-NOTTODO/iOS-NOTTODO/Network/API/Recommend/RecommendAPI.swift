//
//  RecommendAPI.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/20.
//

import Foundation

import Moya

final class RecommendAPI {
    
    static let shared: RecommendAPI = RecommendAPI()
    
    private let recommendProvider = MoyaProvider<RecommendService>(plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var recommendData: GeneralArrayResponse<RecommendResponseDTO>?
    
    // MARK: - GET
    
    func getRecommend(completion: @escaping (GeneralArrayResponse<RecommendResponseDTO>?) -> Void) {
        recommendProvider.request(.recommend) { result in
            switch result {
            case .success(let response):
                do {
                    self.recommendData = try response.map(GeneralArrayResponse<RecommendResponseDTO>?.self)
                    guard let recommendData = self.recommendData else { return }
                    completion(recommendData)
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
