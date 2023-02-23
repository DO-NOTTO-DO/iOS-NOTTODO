//
//  RecommendModel.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

struct RecommendModel {
    let tag: String
    let title: String
    let body: String
    let image: String
}

// test

var recommendList: [RecommendModel] = [
    RecommendModel(tag: "업무 시간 중", title: "유튜브 보지 않기", body: "유튜브를 보지 않는 것이 당신의 일상에 어떠한 변화를 일으킬까요? 행복한 중독 해소를 위해 제안해요!", image: .youtube),
    RecommendModel(tag: "취침 전", title: "커피 마시지 않기", body: "한국인들은 평균 2잔의 커피를 마신대요. 적당한 섭취를 위해 제안해요!", image: .coffee)
]
