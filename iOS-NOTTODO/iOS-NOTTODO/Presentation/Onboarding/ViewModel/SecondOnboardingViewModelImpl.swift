//
//  SecondOnboardingViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

final class SecondOnboardingViewModelImpl: SecondOnboardingViewModel {
    
    private weak var coordinator: AuthCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: SecondOnboardingViewModelInput) -> SecondOnboardingViewModelOutput {
        input.cellTapped
            .sink { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showThirdOnboardingViewController()
            }
            .store(in: &cancelBag)
        return SecondOnboardingViewModelOutput()
    }
}
