//
//  RecommendAPI.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/20.
//

import Foundation

import Moya

enum RecommendAPI {
    case recommend
    case action(id: Int)
    case situdation
}

extension RecommendAPI: BaseAPI {
    var domain: BaseDomain {
        return .recommend
    }
    
    var urlPath: String {
        switch self {
        case .recommend:
            return URLConstant.recommend
        case .action(id: let id):
            return URLConstant.recommendAction + "/\(id)" + "/action"
        case .situdation:
            return URLConstant.recommendSituation
        }
    }
    
    var headerType: HeaderType {
        return .jsonWithToken
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var task: Moya.Task {
        .requestPlain
    }
}
