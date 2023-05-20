//
//  DailyMissionResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/20.
//

import Foundation

// MARK: - DailyMissionResponseDTO

struct DailyMissionResponseDTO: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [DailyData]
}

// MARK: - Datum

struct DailyData: Codable {
    let id: Int
    let title, situationName, completionStatus: String
}
