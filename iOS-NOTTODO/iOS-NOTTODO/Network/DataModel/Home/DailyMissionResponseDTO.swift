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
    
    var uuid =  UUID()
    let id: Int
    let title: String
    let situationName: String
    let completionStatus: CompletionStatus
    
    enum CodingKeys: String, CodingKey {
        case id, title, situationName, completionStatus
    }
    
    static func == (lhs: DailyMissionResponseDTO, rhs: DailyMissionResponseDTO) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
