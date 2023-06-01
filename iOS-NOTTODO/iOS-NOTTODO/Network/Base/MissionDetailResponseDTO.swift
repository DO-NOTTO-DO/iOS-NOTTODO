//
//  MissionDetailResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/18.
//

import Foundation

// MARK: - MissionDetailResponseDTO

struct MissionDetailResponseDTO: Codable, Hashable {
    let id: Int
    let title, situation: String
    let actions: [Action]
    let goal: String
    let count: Int
}

// MARK: - Action

struct Action: Codable, Hashable {
    let name: String
}
