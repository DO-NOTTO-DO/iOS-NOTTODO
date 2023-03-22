//
//  OnboardingModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import Foundation

struct SecondOnboardingModel: Hashable {
    var title: String
}
extension SecondOnboardingModel {
    static let titles: [SecondOnboardingModel] = [SecondOnboardingModel(title: "고치고 싶은 나쁜 습관이 있어요"),
                                            SecondOnboardingModel(title: "루틴대로 하루를 보내지 못해요"),
                                            SecondOnboardingModel(title: "계획만 세우고 목표를 달성하지 못해요"),
                                            SecondOnboardingModel(title: "불필요한 행위로 시간을 뻇겨요"),
                                            SecondOnboardingModel(title: "불편함은 없지만 낫투두를 시도하고 싶어요")
    ]
}

struct ThirdOnboardingModel: Hashable {
    var title: String
}
extension ThirdOnboardingModel {
    static let titles: [ThirdOnboardingModel] = [ThirdOnboardingModel(title: "언제나"),
                                                 ThirdOnboardingModel(title: "업무할 때"),
                                                 ThirdOnboardingModel(title: "공부할 때"),
                                                 ThirdOnboardingModel(title: "출근할 때"),
                                                 ThirdOnboardingModel(title: "퇴근할 때"),
                                                 ThirdOnboardingModel(title: "일어나자마자"),
                                                 ThirdOnboardingModel(title: "잠깐 쉴 때"),
                                                 ThirdOnboardingModel(title: "잠들기 직전"),
                                                 ThirdOnboardingModel(title: "기타")
    ]
}
struct FourOnboardingModel: Hashable {
    var icon: UIImage
    var tag: String
    var title: String
}
extension FourOnboardingModel {
    static let items: [FourOnboardingModel] = [FourOnboardingModel(icon: .youtube, tag: "취침 전", title: "유튜브 추천 영상 생각없이 보지 않기"),
                                               FourOnboardingModel(icon: .delivery, tag: "항상", title: "배민 VIP 탈출하기"),
                                               FourOnboardingModel(icon: .coffee, tag: "기상 직후", title: "공복에 커피 마시지 않기"),
                                               FourOnboardingModel(icon: .kakao, tag: "업무 중", title: "불필요한 PC 카톡 하지 않기"),
                                               FourOnboardingModel(icon: .food, tag: "취침 전", title: "자기 2시간 전 야식 먹지 않기")
    ]
}
