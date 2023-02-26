//
//  MissionListModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/26.
//

import Foundation

struct MissionListModel {
    var tag: String
    var missiontitle: String
}
extension MissionListModel {
    static let items: [MissionListModel] = [ MissionListModel(tag: "밥 먹을 때", missiontitle: "배민 vip 탈출하기"),
                                             MissionListModel(tag: "아침", missiontitle: "공복에 커피 마시지 않기"),
                                             MissionListModel(tag: "출근 시간", missiontitle: "아침 거르지 않기")
    ]
}
