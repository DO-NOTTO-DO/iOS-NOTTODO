//
//  MyInfoModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import Foundation

struct MyInfoModel1: Hashable {
    var image: String
    var user: String
    var email: String
}
extension MyInfoModel1 {
    static let item: [MyInfoModel1] = [MyInfoModel1(image: "img_myinfouser", user: "내이름은노또", email: "ghdtjgus123@kakao.com")]
}

struct MyInfoModel2: Hashable {
    var image: String
    var title: String
}
extension MyInfoModel2 {
    static let items: [MyInfoModel2] = [MyInfoModel2(image: "btn_checkbox_inactive", title: "낫투두 가이드"),
                                        MyInfoModel2(image: "btn_checkbox_inactive", title: "자주 묻는 질문")
    ]
}

struct MyInfoModel3: Hashable {
    var title: String
}
extension MyInfoModel3 {
    static let items: [MyInfoModel3] = [MyInfoModel3(title: "공지사항"),
                                        MyInfoModel3(title: "문의하기"),
                                        MyInfoModel3(title: "약관 및 정책")
    ]
}

struct MyInfoModel4: Hashable {
    var title: String
}
extension MyInfoModel4 {
    static let item: [MyInfoModel4] = [MyInfoModel4(title: "버전 정보 0.0.1")]
}
