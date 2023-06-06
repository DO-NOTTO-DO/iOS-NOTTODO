//
//  RecommendDTO.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/20.
//

import Foundation

struct RecommendResponseDTO: Codable, Hashable {
    let id: Int
    let title: String
    let situation: String
    let description: String
    let image: String
}
