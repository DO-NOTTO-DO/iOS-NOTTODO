//
//  ThirdOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

protocol ThirdOnboardingViewModel: ViewModel where Input == ThirdOnboardingViewModelInput, Output == ThirdOnboardingViewModelOutput {}

struct ThirdOnboardingViewModelInput {
    let viewDidLoadSubject: PassthroughSubject<Void, Never>
    let nextButtonDidTapped: PassthroughSubject<[String], Never>
}

struct ThirdOnboardingViewModelOutput {}
