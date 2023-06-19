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
    case addMission(title: String, situation: String, actions: [String]?, goal: String?, dates: [String])
}

extension AddMissionService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .recommendSituation:
            return URLConstant.recommendSituation
        case .addMission:
            return URLConstant.addMission
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recommendSituation:
            return .get
        case .addMission:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .recommendSituation:
            return .requestPlain
        case .addMission(let title, let situation, let actions, let goal, let dates):
            return .requestParameters(
                parameters: ["title": title, "situation": situation, "actions": actions ?? "",
                             "goal": goal ?? "", "dates": dates],
                encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return NetworkConstant.hasTokenHeader
        }
    }
}
