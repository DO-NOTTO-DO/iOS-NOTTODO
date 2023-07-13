//
//  RecommendActionResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

struct RecommendActionResponseDTO: Codable {
    let id: Int
    let title: String
    let recommendActions: [RecommendActions]
}

struct RecommendActions: Codable {
    let name: String
    let description: String
}
