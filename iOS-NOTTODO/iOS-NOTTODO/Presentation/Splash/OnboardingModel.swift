//
//  OnboardingModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import Foundation

struct OnboardingModel: Hashable {
    var title: String
}
extension OnboardingModel {
    static let titles: [OnboardingModel] = [OnboardingModel(title: "고치고 싶은 나쁜 습관이 있어요"),
                                            OnboardingModel(title: "루틴대로 하루를 보내지 못해요"),
                                            OnboardingModel(title: "계획만 세우고 목표를 달성하지 못해요"),
                                            OnboardingModel(title: "불필요한 행위로 시간을 뻇겨요"),
                                            OnboardingModel(title: "불편함은 없지만 낫투두를 시도하고 싶어요")
    ]
}
