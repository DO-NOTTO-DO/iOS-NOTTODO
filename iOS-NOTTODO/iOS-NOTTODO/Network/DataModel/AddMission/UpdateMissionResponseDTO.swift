//
//  UpdateMissionResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/24.
//

import Foundation

struct UpdateMissionResponseDTO: Codable {
    let title: String
    let goal: String?
    let situation: String
    let actions: [Action]?
}
