//
//  ValueOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

protocol ValueOnboardingViewModel: ViewModel where Input == ValueOnboardingViewModelInput, Output == ValueOnboardingViewModelOutput {}

struct ValueOnboardingViewModelInput {
    let endAnimationSubject: PassthroughSubject<Void, Never>
}

struct ValueOnboardingViewModelOutput { }
