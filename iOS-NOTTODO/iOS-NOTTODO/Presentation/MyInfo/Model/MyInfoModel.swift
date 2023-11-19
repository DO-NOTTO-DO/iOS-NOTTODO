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
    
    static let support: [InfoModel] = [InfoModel(image: .icGuide, title: "낫투두 가이드"),
                                       InfoModel(image: .icQuestion1, title: "자주 묻는 질문")
    ]
    static let info: [InfoModel] = [InfoModel(title: "공지사항"),
                                    InfoModel(title: "문의하기"),
                                    InfoModel(title: "약관 및 정책")
    ]
    static func version() -> [InfoModel] { return  [InfoModel(title: "버전 정보 "+(Utils.version ?? "1.0.0"))] }
}
