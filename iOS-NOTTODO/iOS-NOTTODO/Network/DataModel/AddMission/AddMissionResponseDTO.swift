//
//  AddMissionResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/20.
//

import Foundation

struct AddMissionResponseDTO: Codable {
    let title: String
    let goal: String?
    let situation: String
    let actions: [Action]?
    let dates: [String]
}
