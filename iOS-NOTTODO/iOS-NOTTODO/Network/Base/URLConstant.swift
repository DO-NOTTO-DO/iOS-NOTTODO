//
//  URLConstant.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import Foundation

struct URLConstant {
            
    // MARK: - Auth
    
    static let auth = "/login"
    static let authLogout = "/logout"
    static let authWithdrawal = "/withdrawal"
    
    // MARK: - Recommend
    
    static let recommend = "/mission"
    static let recommendAction = ""
    static let recommendSituation = "/situation"
    
    // MARK: - Achieve
    
    static let achieveCalendar = "/month"
    
    // MARK: - Home
    
    static let dailyMission = "/daily"
    static let missionWeekly = "/week"
    static let mission = ""
    
    // MARK: - AddMission
    
    static let recentMission = "/recent"
    
    // MARK: - Widget
    
    static let quote = "/quote/random"
}
