//
//  DetailAchievementModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation

struct AchieveDetailData: Hashable {
    
    let missionList: [DailyMissionResponseDTO]
    let selectedDate: String
    
    func formatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: selectedDate) else { return "" }
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
}
