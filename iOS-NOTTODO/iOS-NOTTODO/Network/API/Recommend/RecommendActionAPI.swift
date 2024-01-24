//
//  RecommendActionAPI.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

final class RecommendActionAPI {
    
    static let shared: RecommendActionAPI = RecommendActionAPI()
    
    private let recommendActionProvider = MoyaProvider<RecommendActionService>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    private init() { }
    
    public private(set) var recommendActionData: GeneralResponse<RecommendActionResponseDTO>?
    
    // MARK: - GET
    
    func getRecommendAction(index: Int, completion: @escaping (GeneralResponse<RecommendActionResponseDTO>?) -> Void) {
        recommendActionProvider.request(.recommendAction(id: index)) { result in
            switch result {
            case .success(let response):
                do {
                    self.recommendActionData = try response.map(GeneralResponse<RecommendActionResponseDTO>?.self)
                    guard let recommendActionData = self.recommendActionData else { return }
                    completion(recommendActionData)
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
