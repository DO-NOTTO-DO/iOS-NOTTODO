//
//  RecommendActionService.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

import Moya

enum RecommendActionService {
    case recommendAction(id: Int)
}

extension RecommendActionService: TargetType {
    var baseURL: URL {
        return URL(string: Bundle.main.baseURL)!
    }
    
    var path: String {
        switch self {
        case .recommendAction(id: let id):
            return URLConstant.recommendAction + "/\(id)" + "/action"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recommendAction:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .recommendAction:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .recommendAction:
            return ["Content-Type": "application/json",
                    "Authorization": "\(KeychainUtil.getAccessToken())"]
        }
    }
}
