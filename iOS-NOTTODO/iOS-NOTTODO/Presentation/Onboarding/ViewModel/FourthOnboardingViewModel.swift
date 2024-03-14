//
//  FourthOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

protocol FourthOnboardingViewModel: ViewModel where Input == FourthOnboardingViewModelInput, Output == FourthOnboardingViewModelOutput {}

struct FourthOnboardingViewModelInput {
    let buttonDidTapped: PassthroughSubject<Void, Never>
}

struct FourthOnboardingViewModelOutput {}
