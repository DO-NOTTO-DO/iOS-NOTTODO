//
//  SecondOnboardingViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine
import Foundation

protocol SecondOnboardingViewModel: ViewModel where Input == SecondOnboardingViewModelInput, Output == SecondOnboardingViewModelOutput { }

struct SecondOnboardingViewModelInput {
    let cellTapped: PassthroughSubject<IndexPath, Never>
}

struct SecondOnboardingViewModelOutput { }
