//
//  MissionListModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/26.
//

import Foundation

struct MissionListModel: Hashable {
    var tag: String
    var missiontitle: String
}
extension MissionListModel {
    static let items: [MissionListModel] = [ MissionListModel(tag: "밥 먹을 때", missiontitle: "배민 vip 탈출하기"),
                                             MissionListModel(tag: "아침", missiontitle: "공복에 커피 마시지 않기"),
                                             MissionListModel(tag: "출근 시간", missiontitle: "아침 거르지 않기")
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
    static let items: [MissionDetailModel] = [ MissionDetailModel(id: 1, title: "밥 먹을 때", situation: "배민 vip 탈출하기", action: ["배달의 민족 어플 삭제하기", "주 1회 마트에서 장보기", "가계부 쓰기"], goal: "불필요한 지출 줄이기", count: 20)
    ]
}
