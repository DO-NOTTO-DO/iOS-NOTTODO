//
//  LogoOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

protocol LogoOnboardingViewModel: ViewModel where Input == LogoOnboardingViewModelInput, Output == LogoOnboardingViewModelOutput {}

struct LogoOnboardingViewModelInput {
    let startButtonTappedSubject: PassthroughSubject<Void, Never>
}

struct LogoOnboardingViewModelOutput {}
