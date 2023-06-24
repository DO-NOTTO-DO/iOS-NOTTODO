//
//  MyInfoModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

struct InfoModelOne: Hashable {
    var image: UIImage
    var user: String
    var email: String
}
//extension InfoModelOne {
//    static var item: [InfoModelOne] = [InfoModelOne(image: .imgUser, user: KeychainUtil.getUsername(), email: KeychainUtil.getEmail())]
//}

struct InfoModelTwo: Hashable {
    var image: UIImage
    var title: String
}
extension InfoModelTwo {
    static let items: [InfoModelTwo] = [InfoModelTwo(image: .icGuide, title: "낫투두 가이드"),
                                        InfoModelTwo(image: .icQuestion1, title: "자주 묻는 질문")
    ]
}

struct InfoModelThree: Hashable {
    var title: String
}
extension InfoModelThree {
    static let items: [InfoModelThree] = [InfoModelThree(title: "공지사항"),
                                          InfoModelThree(title: "문의하기"),
                                          InfoModelThree(title: "약관 및 정책"),
                                          InfoModelThree(title: "오픈소스 라이선스")
    ]
}

struct InfoModelFour: Hashable {
    var title: String
}
extension InfoModelFour {
    static let item: [InfoModelFour] = [InfoModelFour(title: "버전 정보 1.0.0")]
}
