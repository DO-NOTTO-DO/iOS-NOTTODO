//
//  FifthOnboardingViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

final class FifthOnboardingViewModelImpl: FifthOnboardingViewModel {
    
    private weak var coordinator: AuthCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: FifthOnboardingViewModelInput) -> FifthOnboardingViewModelOutput {
        input.loginButtonDidTapped
            .sink { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showSignUpViewController()
            }
            .store(in: &cancelBag)
        return FifthOnboardingViewModelOutput()
    }
}
