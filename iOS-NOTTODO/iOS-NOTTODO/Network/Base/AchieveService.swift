//
//  AchieveService.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/18.
//

import Foundation

import Moya

enum AchieveService {
    case achieveCalendar(month: String)
    case achieveDetail(missionId: Int )
}

extension AchieveService: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .achieveCalendar(let month):
            return URLConstant.achieveCalendar + "/\(month)"
        case .achieveDetail(let id):
            return URLConstant.achieveDetail + "/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .achieveCalendar, .achieveDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .achieveCalendar, .achieveDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .achieveCalendar, .achieveDetail:
            return NetworkConstant.hasTokenHeader
        }
    }
}
