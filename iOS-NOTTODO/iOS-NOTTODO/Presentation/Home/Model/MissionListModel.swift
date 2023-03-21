//
//  MissionListModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/26.
//

import Foundation
enum CompletionStatus: String, Codable {
    case CHECKED, UNCHECKED
}
struct MissionListModel: Hashable {
    var id: Int
    var title: String
    var situation: String
    var completionStatus: CompletionStatus
}
extension MissionListModel {
    static let items: [MissionListModel] = [ MissionListModel(id: 1, title: "밥 먹을 때", situation: "배민 vip 탈출하기", completionStatus: .CHECKED),
                                             MissionListModel(id: 2, title: "아침", situation: "공복에 커피 마시지 않기", completionStatus: .UNCHECKED),
                                             MissionListModel(id: 3, title: "출근 시간", situation: "아침 거르지 않기", completionStatus: .UNCHECKED)
    ]
//    static let items: [MissionListModel] = []
}

struct MissionDetailModel: Hashable {
    var id: Int
    var title: String
    var situation: String
    var action: [String]?
    var goal: String
    var count: Int
}
extension MissionDetailModel {
    static let items: [MissionDetailModel] = [ MissionDetailModel(id: 1, title: "밥 먹을 때", situation: "배민 vip 탈출하기", action: ["배달의 민족 어플 삭제하기", "주 1회 마트에서 장보기", "가계부 쓰기"], goal: "불필요한 지출 줄이기", count: 20),
                                               MissionDetailModel(id: 2, title: "아침", situation: "공복에 커피 마시지 않기", action: ["공복", "커피", "금지"], goal: "지출 줄이기", count: 80),
                                               MissionDetailModel(id: 3, title: "출근 시간", situation: "아침 거르지 않기", action: ["아침", "매일", "먹기"], goal: "불필요", count: 10)
    ]
}
