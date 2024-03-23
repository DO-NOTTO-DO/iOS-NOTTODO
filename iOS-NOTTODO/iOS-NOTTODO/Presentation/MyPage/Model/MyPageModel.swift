//
//  MyPageModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import UIKit

struct MyPageModel: Hashable {
    let sections: [Section]
    
    enum Section: Int, CaseIterable {
        case profile, support, info, version
        
        var rows: [MyPageRowData] {
            switch self {
            case .profile:
                return MyPageRowData.profile
            case .support:
                return MyPageRowData.support
            case .info:
                return MyPageRowData.info
            case .version:
                return MyPageRowData.version()
            }
        }
        var events: [AnalyticsEvent.MyInfo] {
            switch self {
            case .profile:
                return [.clickMyInfo]
            case .support:
                return [.clickGuide, .clickFaq]
            case .info:
                return [.clickNotice, .clickSuggestion, .clickQuestion, .clickTerms]
            case .version:
                return []
            }
        }
        
        var urls: [MyInfoURL] {
            switch self {
            case .profile:
                return []
            case .support:
                return [.guid, .faq]
            case .info:
                return [.notice, .suggestoin, .question, .service]
            case .version:
                return []
            }
        }
    }
}

struct MyPageRowData: Hashable {
    var image: UIImage?
    var user: String?
    var email: String?
    var title: String?
    var isArrowHidden: Bool = false
    
    static var profile: [MyPageRowData] {
        let user = UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleUsername() : KeychainUtil.getKakaoNickname()
        let email = UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleEmail() : KeychainUtil.getKakaoEmail()
        return [MyPageRowData(image: .imgUser, user: user, email: email)]
    }
    
    static let support: [MyPageRowData] = [
        MyPageRowData(image: .icGuide, title: I18N.guide),
        MyPageRowData(image: .icQuestion1, title: I18N.oftenQuestion)
    ]
    
    static let info: [MyPageRowData] = [
        MyPageRowData(title: I18N.notice),
        MyPageRowData(title: I18N.sendFeedback),
        MyPageRowData(title: I18N.inquiry),
        MyPageRowData(title: I18N.policies)
    ]
    
    static func version() -> [MyPageRowData] {
        return [MyPageRowData(title: I18N.version + " " + (Utils.version ?? "1.0.0"), isArrowHidden: true)]
    }
}
