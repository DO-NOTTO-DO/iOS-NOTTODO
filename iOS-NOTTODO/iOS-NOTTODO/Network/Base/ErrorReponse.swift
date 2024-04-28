//
//  ErrorReponse.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation

struct ErrorResponse: Decodable, Equatable {
    let status: Int
    let success: Bool
    let message: String
}
