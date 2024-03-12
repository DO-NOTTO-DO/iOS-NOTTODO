//
//  ErrorReponse.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation

public struct ErrorResponse: Decodable, Equatable {
    public let statusCode: String
    public let responseMessage: String
}
