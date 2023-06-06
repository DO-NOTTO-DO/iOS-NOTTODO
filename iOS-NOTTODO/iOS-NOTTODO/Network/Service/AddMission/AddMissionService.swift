//
//  AddMissionService.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/07.
//

import Foundation

import Moya

enum AddMissionService {
    case recommendSituation
}

extension AddMissionService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .recommendSituation:
            return URLConstant.recommendSituation
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recommendSituation:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .recommendSituation:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .recommendSituation:
            return NetworkConstant.hasTokenHeader
        }
    }
}
