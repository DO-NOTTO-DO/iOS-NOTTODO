//
//  DailyMissionResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/20.
//

import Foundation

enum CompletionStatus: String, Codable, Hashable {
    case CHECKED, UNCHECKED
}

// MARK: - DailyMissionResponseDTO

struct DailyMissionResponseDTO: Codable, Hashable {
    var id: Int
    var title: String
    var situationName: String
    var completionStatus: CompletionStatus
}
