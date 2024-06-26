//
//  DefaultKeys.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/06/14.
//

import Foundation

enum LoginType: String, Codable, CaseIterable {
    case KAKAO, APPLE
}

struct DefaultKeys {
    static let kakaoEmail = "kakaoEmail"
    static let kakaoNickname = "kakaoNickname"
    static let appleEmail = "appleEmail"
    static let appleName = "appleName"
    static let isAppleLogin = "isAppleLogin"
    static let socialToken = "socialToken"
    static let accessToken = "accessToken"
    static let fcmToken = "fcmToken"
    static let isNotificationAccepted = "isNotificationAccepted"
    static let isDeprecatedBtnClicked = "isDeprecatedBtnClicked"
}
