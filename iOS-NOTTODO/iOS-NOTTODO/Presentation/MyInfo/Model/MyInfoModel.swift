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
extension InfoModelOne {
    static let item: [InfoModelOne] = [InfoModelOne(image: .imgUser, user: "내이름은노또", email: "ghdtjgus123@kakao.com")]
}

struct InfoModelTwo: Hashable {
    var image: UIImage
    var title: String
}
extension InfoModelTwo {
    static let items: [InfoModelTwo] = [InfoModelTwo(image: .icGuide, title: "낫투두 가이드"),
                                        InfoModelTwo(image: .icQuestion , title: "자주 묻는 질문")
    ]
}

struct InfoModelThree: Hashable {
    var title: String
}
extension InfoModelThree {
    static let items: [InfoModelThree] = [InfoModelThree(title: "공지사항"),
                                          InfoModelThree(title: "문의하기"),
                                          InfoModelThree(title: "약관 및 정책")
    ]
}

struct InfoModelFour: Hashable {
    var title: String
}
extension InfoModelFour {
    static let item: [InfoModelFour] = [InfoModelFour(title: "버전 정보 0.0.1")]
}
