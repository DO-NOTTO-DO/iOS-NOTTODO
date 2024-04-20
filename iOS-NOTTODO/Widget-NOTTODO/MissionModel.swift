//
//  MissionModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 4/14/24.
//

import SwiftUI

struct MissionModel: Identifiable {
    var id = UUID().uuidString
    var missionTitle: String
    var isCompleted: Bool = false
}

class MissionDataModel {
    static let shared = MissionDataModel()
    
    var model: [MissionModel] = [
        .init(missionTitle: "바마바ㅏ어람니어리 ㅏㅓㅏ어라너ㅏㅇ러라언", isCompleted: true),
        .init(missionTitle: "바마바ㅏ어람니어리 ㅏㅓㅏ어라너ㅏㅇ러라언"),
        .init(missionTitle: "바마바ㅏ어람니어리 ㅏㅓㅏ어라너ㅏㅇ러라언"),
        .init(missionTitle: "바마바ㅏ어람니어리 ㅏㅓㅏ어라너ㅏㅇ러라언"),
        .init(missionTitle: "바마바ㅏ어람니어리 ㅏㅓㅏ어라너ㅏㅇ러라언"),
        .init(missionTitle: "바마바ㅏ어람니어리 ㅏㅓㅏ어라너ㅏㅇ러라언")
    ]
}
