//
//  APIError.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation

public enum APIError: Error, Equatable {
    case network(statusCode: Int, response: ErrorResponse)
    case unknown
    case tokenReissuanceFailed
    
    init(error: Error, statusCode: Int? = 0, response: ErrorResponse) {
        guard let statusCode else { self = .unknown ; return }
        
        self = .network(statusCode: statusCode, response: response)
    }
}
