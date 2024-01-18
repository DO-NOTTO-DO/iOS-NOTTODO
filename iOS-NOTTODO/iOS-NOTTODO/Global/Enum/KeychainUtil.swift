//
//  KeychainUtil.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/06/14.
//

import Foundation

public final class KeychainUtil {

    static func setSocialToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: DefaultKeys.socialToken)
    }
    static func setAccessToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: DefaultKeys.accessToken)
    }
    static func setFcmToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: DefaultKeys.fcmToken)
    }
    static func setString(_ value: String?, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    static func setBool(_ value: Bool?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    static func getSocialToken() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.socialToken) ?? ""
    }
    static func getAccessToken() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.accessToken) ?? ""
    }
    static func getFcmToken() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.fcmToken) ?? ""
    }
    static func getKakaoNickname() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.kakaoNickname) ?? "익명의 도전자"
    }
    static func getKakaoEmail() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.kakaoEmail) ?? "연동된 이메일 정보가 없습니다"
    }
    static func getAppleUsername() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.appleName) ?? "익명의 도전자"
    }
    static func getAppleEmail() -> String {
        UserDefaults.standard.string(forKey: DefaultKeys.appleEmail) ?? "연동된 이메일 정보가 없습니다"
    }
    static func getBool(_ key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    static func isSelected() -> Bool {
        UserDefaults.standard.bool(forKey: DefaultKeys.isSelected)
    }
        
    static func removeUserInfo() {
        if UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) {
            UserDefaults.standard.removeObject(forKey: DefaultKeys.appleName)
            UserDefaults.standard.removeObject(forKey: DefaultKeys.appleEmail)
        } else {
            UserDefaults.standard.removeObject(forKey: DefaultKeys.kakaoEmail)
            UserDefaults.standard.removeObject(forKey: DefaultKeys.kakaoNickname)
        }
        
        UserDefaults.standard.removeObject(forKey: DefaultKeys.socialToken)
        UserDefaults.standard.removeObject(forKey: DefaultKeys.accessToken)
    }
}
