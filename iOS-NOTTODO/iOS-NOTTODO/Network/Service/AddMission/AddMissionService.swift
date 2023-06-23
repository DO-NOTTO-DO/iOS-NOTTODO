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
    case updateMission(id: Int, title: String, situation: String, actions: [String]?, goal: String?)
    case recentMission
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
            return URLConstant.mission
        case .updateMission(let id, _, _, _, _):
            return URLConstant.mission + "/\(id)"
        case .recentMission:
            return URLConstant.recentMission
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recommendSituation, .recentMission:
            return .get
        case .addMission:
            return .post
        case .updateMission:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .recommendSituation, .recentMission:
            return .requestPlain
        case .addMission(let title, let situation, let actions, let goal, let dates):
            return .requestParameters(
                parameters: ["title": title, "situation": situation, "actions": actions ?? "",
                             "goal": goal ?? "", "dates": dates],
                encoding: JSONEncoding.default)
        case .updateMission(_, let title, let situation, let actions, let goal):
            return .requestParameters(
                parameters: ["title": title, "situation": situation,
                             "actions": actions ?? [""], "goal": goal ?? ""],
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
