//
//  DefaultKeys.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/06/14.
//

import Foundation

enum LoginType {
    case Kakao, Apple
    
    var social: String {
        switch self {
        case .Kakao: return "KAKAO"
        case .Apple: return "APPLE"
        }
    }
}

struct DefaultKeys {
    static let userId = "userId"
    static let email = "email"
    static let name = "name"
    static let isAppleLogin = "isAppleLogin"
    static let isKakaoLogin = "isKakaoLogin"
    static let socialToken = "socialToken"
    static let accessToken = "accessToken"
    static let fcmToken = "1"
}
