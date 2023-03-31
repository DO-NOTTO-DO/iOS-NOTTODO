//
//  RecommendModels.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/20.
//

import Foundation

struct RecommendKeywordModel {
    var keyword: String
}

extension RecommendKeywordModel {
    static let items: [RecommendKeywordModel] = [
        RecommendKeywordModel(keyword: "업무 시간 중"),
        RecommendKeywordModel(keyword: "작업 중"),
        RecommendKeywordModel(keyword: "기상 시간"),
        RecommendKeywordModel(keyword: "공부 시간"),
        RecommendKeywordModel(keyword: "취침 전"),
        RecommendKeywordModel(keyword: "출근 중")
    ]
}
