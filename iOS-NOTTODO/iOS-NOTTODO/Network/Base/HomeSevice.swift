//
//  HomeSevice.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/20.
//

import Foundation

import Moya

enum HomeService {
    case dailyMission(date: String)
    case updateMissionStatus(id: Int, status: String)
    case missionWeekly(startDate: String)
}

extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .dailyMission(let date):
            return URLConstant.dailyMission + "/\(date)"
        case .missionWeekly(let startDate):
            return URLConstant.missionWeekly + "/\(startDate)"
        case .updateMissionStatus(let id, _):
            return URLConstant.mission + "/\(id)" + "/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .dailyMission, .missionWeekly:
            return .get
        case .updateMissionStatus:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .dailyMission, .missionWeekly:
            return .requestPlain
        case .updateMissionStatus(_, let status):
            return .requestParameters(parameters: ["completionStatus": status],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
