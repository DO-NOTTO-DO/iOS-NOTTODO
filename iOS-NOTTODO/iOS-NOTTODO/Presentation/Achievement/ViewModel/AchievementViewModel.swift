//
//  AchievementViewModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/12/24.
//

import Foundation
import Combine

protocol AchievementViewModelPresentable {}
protocol AchievementViewModel: ViewModel where Input == AchievementViewModelInput, Output == AchievementViewModelOutput {}

struct AchievementViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let calendarCellTapped: PassthroughSubject<Date, Never>
    let currentMonthSubject: PassthroughSubject<Date, Never>
}

struct AchievementViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<CalendarEventData, Never>
}
