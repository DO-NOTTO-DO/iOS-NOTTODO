//
//  NetworkError.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 5/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case networkError
    case dataParsingError
    case invalidRequestParameters
    case encodingFailed
    case internalError(message: String)
}
