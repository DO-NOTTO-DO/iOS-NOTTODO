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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .dailyMission, .missionWeekly:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .dailyMission, .missionWeekly:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
