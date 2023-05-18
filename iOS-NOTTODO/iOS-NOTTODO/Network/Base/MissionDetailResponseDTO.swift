//
//  MissionDetailResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/05/18.
//

import Foundation

// MARK: - MissionDetailResponseDTO

struct MissionDetailResponseDTO: Codable {
    
    let id: Int
    let title, situation: String
    let actions: [Action]
    let goal: String
    let count: Int
}

// MARK: - Action

struct Action: Codable {
    let name: String
}
