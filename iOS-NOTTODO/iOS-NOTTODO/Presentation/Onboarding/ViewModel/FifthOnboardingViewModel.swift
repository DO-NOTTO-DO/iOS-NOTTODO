//
//  FifthOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

protocol FifthOnboardingViewModel: ViewModel where Input == FifthOnboardingViewModelInput, Output == FifthOnboardingViewModelOutput {}

struct FifthOnboardingViewModelInput {
    let viewDidLoadSubject: PassthroughSubject<Void, Never>
    let loginButtonDidTapped: PassthroughSubject<Void, Never>
}

struct FifthOnboardingViewModelOutput {}
