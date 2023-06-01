//
//  URLConstant.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import Foundation

struct URLConstant {
    
    // MARK: - base URL
    
    static let baseURL = "http://43.201.125.166:8080/api/v1"
    
    // MARK: - Auth
    
    static let auth = "/auth"
    
    // MARK: - Achieve
    
    static let achieveCalendar = "/mission/month"
    static let achieveDetail = "/mission"
    
    // MARK: - Recommend
    
    static let recommend = "/recommend/mission"
    
    // MARK: - RecommendAction
    
    static let recommendAction = "/recommend"
    
    // MARK: - Home
    
    static let dailyMission = "/mission/daily"
    static let missionWeekly = "/mission/week"
    static let mission = "/mission"
}
