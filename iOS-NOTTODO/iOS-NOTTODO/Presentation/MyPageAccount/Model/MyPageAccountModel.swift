//
//  MyPageAccountModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import UIKit

struct MyPageAccountModel: Equatable {
    let profileData: [AccountRowData]
    let logout: [AccountRowData]
}

struct AccountRowData: Hashable {
    var uuid = UUID()
    var title: String
    var content: String?
    var titleColor: UIColor = .white
    var isSwitch: Bool = false
    var isOn: Bool = false
    
    static func userInfo() -> [AccountRowData] {
        return [AccountRowData(title: I18N.nickname,
                               content: KeychainUtil.getBool(DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleUsername() : KeychainUtil.getKakaoNickname()),
                AccountRowData(title: I18N.email,
                               content: KeychainUtil.getBool(DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleEmail() : KeychainUtil.getKakaoEmail()),
                AccountRowData(title: I18N.account,
                               content: KeychainUtil.getBool(DefaultKeys.isAppleLogin) ? "apple" : "kakao"),
                AccountRowData(title: I18N.notification, isSwitch: true)]
    }
    
    static func logout() -> [AccountRowData] {
        return [AccountRowData(title: I18N.logout,
                               titleColor: .ntdRed!)]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: AccountRowData, rhs: AccountRowData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
