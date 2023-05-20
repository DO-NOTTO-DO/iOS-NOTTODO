//
//  UpdateMissionResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/21.
//

import Foundation

struct UpdateMissionResponseDTO: Codable {
    let id: Int
    let title, situationName,completionStatus: String
}
