//
//  MyInfoModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

struct InfoModel: Hashable {
    
    var image: UIImage?
    var user: String?
    var email: String?
    var title: String?
    
    static var profile: [InfoModel] = [InfoModel(image: .imgUser,
                                                 user: UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleUsername() : KeychainUtil.getKakaoNickname(),
                                                 email: UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleEmail() : KeychainUtil.getKakaoEmail())]
    
    static let support: [InfoModel] = [InfoModel(image: .icGuide, title: I18N.guide),
                                       InfoModel(image: .icQuestion1, title: I18N.oftenQuestion)
    ]
    static let info: [InfoModel] = [InfoModel(title: I18N.notice),
                                    InfoModel(title: I18N.sendFeedback),
                                    InfoModel(title: I18N.inquiry),
                                    InfoModel(title: I18N.policies)
    ]
    static func version() -> [InfoModel] { return  [InfoModel(title: I18N.version+(Utils.version ?? "1.0.0"))] }
}
