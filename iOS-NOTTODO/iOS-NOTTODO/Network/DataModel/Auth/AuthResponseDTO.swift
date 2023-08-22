//
//  AuthResponseDTO.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/21.
//

import Foundation

struct AuthResponseDTO: Codable {
    let accessToken: String
    let userId: String
}
