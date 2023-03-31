//
//  MissionHistoryModels.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/21.
//

import Foundation

struct MissionHistoryModel {
    var missionTitle: String
}

extension MissionHistoryModel {
    static let items: [MissionHistoryModel] = [
        MissionHistoryModel(missionTitle: "쓸데없는 계획 세우지 않기"),
        MissionHistoryModel(missionTitle: "낫투두 열심히 하기"),
        MissionHistoryModel(missionTitle: "운동 빠지지 않기"),
        MissionHistoryModel(missionTitle: "1일 1커밋 하기"),
        MissionHistoryModel(missionTitle: "군것질 비율 줄이기"),
        MissionHistoryModel(missionTitle: "유튜브 보지 않기"),
        MissionHistoryModel(missionTitle: "쓸데없는 계획 세우지 않기"),
        MissionHistoryModel(missionTitle: "쓸데없는 계획 세우지 않기"),
        MissionHistoryModel(missionTitle: "쓸데없는 계획 세우지 않기")
    ]
}
