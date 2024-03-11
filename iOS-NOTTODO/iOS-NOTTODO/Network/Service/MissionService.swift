//
//  MissionService.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/07.
//

import Foundation

import Moya

struct AddMissionRequest: Codable {
    let title: String
    let situation: String
    let actions: [String]?
    let goal: String?
    let dates: [String]
}

struct UpdateMissionRequest: Codable {
    let id: Int
    let title: String
    let situation: String
    let actions: [String]?
    let goal: String?
}

enum MissionService {
    case addMission(request: AddMissionRequest)
    case updateMission(request: UpdateMissionRequest)
    case recentMission
    case dailyMission(date: String)
    case updateMissionStatus(id: Int, status: String)
    case deleteMission(id: Int)
    case addAnotherDay(id: Int, dates: [String])
    case missionWeekly(startDate: String)
    case detailMission(id: Int) // case achieveDetail(missionId: Int )
    case particularMission(id: Int) // case missionDates(id: Int)
    case achieveCalendar(month: String)
}

extension MissionService: BaseService {
    var domain: BaseDomain {
        return .mission
    }
    
    var urlPath: String {
        switch self {
        case .addMission:
            return URLConstant.mission
        case .recentMission:
            return URLConstant.recentMission
        case .dailyMission(let date):
            return URLConstant.dailyMission + "/\(date)"
        case .updateMissionStatus(let id, _):
            return URLConstant.mission + "/\(id)" + "/check"
        case .missionWeekly(let startDate):
            return URLConstant.missionWeekly + "/\(startDate)"
        case .particularMission(let id):
            return URLConstant.mission + "/\(id)/dates"
        case .achieveCalendar(let month):
            return URLConstant.achieveCalendar + "/\(month)"
        case .deleteMission(let id), .addAnotherDay(let id, _), .detailMission(let id):
            return URLConstant.mission + "/\(id)"
        case .updateMission(let data):
            return URLConstant.mission + "/\(data.id)"
        }
    }
    
    var headerType: HeaderType {
        return .jsonWithToken
    }
    
    var method: Moya.Method {
        switch self {
        case .addMission, .addAnotherDay:
            return .post
        case .updateMission:
            return .put
        case .deleteMission:
            return .delete
        case .updateMissionStatus:
            return .patch
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .addMission(let data):
            return .requestJSONEncodable(data)
        case .updateMission(let data):
            return .requestJSONEncodable(data)
        case .updateMissionStatus(_, let status):
            return .requestParameters(parameters: ["completionStatus": status],
                                      encoding: JSONEncoding.default)
        case .addAnotherDay(_, let dates):
            return .requestParameters(parameters: ["dates": dates],
                                      encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
}
