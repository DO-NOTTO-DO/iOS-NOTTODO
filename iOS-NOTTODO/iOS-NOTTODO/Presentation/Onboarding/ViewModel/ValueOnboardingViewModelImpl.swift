//
//  ValueOnboardingViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

final class ValueOnboardingViewModelImpl: ValueOnboardingViewModel {

    private weak var coordinator: AuthCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: ValueOnboardingViewModelInput) -> ValueOnboardingViewModelOutput {
        input.endAnimationSubject
            .sink { [weak self] _ in
                self?.coordinator?.showLogoOnboardingViewController()
            }
            .store(in: &cancelBag)
        
        return ValueOnboardingViewModelOutput()
    }
    
}
