//
//  RecommendService.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/20.
//

import Foundation

import Moya

enum RecommendService {
    case recommend
}

extension RecommendService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .recommend:
            return URLConstant.recommend
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recommend:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .recommend:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .recommend:
            return ["Content-Type": "application/json",
                    "Authorization": "\(KeychainUtil.getAccessToken())"]
        }
    }
}
