//
//  FifthOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

protocol FifthOnboardingViewModel: ViewModel where Input == FifthOnboardingViewModelInput, Output == FifthOnboardingViewModelOutput {}

struct FifthOnboardingViewModelInput {
    let loginButtonDidTapped: PassthroughSubject<Void, Never>
}

struct FifthOnboardingViewModelOutput {}
