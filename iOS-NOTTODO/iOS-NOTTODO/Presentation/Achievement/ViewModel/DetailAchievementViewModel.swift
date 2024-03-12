//
//  DetailAchievementViewModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

protocol DetailAchievementViewModelPresentable {}
protocol DetailAchievementViewModel: ViewModel where Input == DetailAchievementViewModelInput, Output == DetailAchievementViewModelOutput {}

struct DetailAchievementViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let dismissSubject: PassthroughSubject<Void, Never>
}

struct DetailAchievementViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<[AchieveDetailData], Never>
}
