//
//  ThirdOnboardingViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

final class ThirdOnboardingViewModelImpl: ThirdOnboardingViewModel {
    
    private weak var coordinator: AuthCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: ThirdOnboardingViewModelInput) -> ThirdOnboardingViewModelOutput {
        input.nextButtonDidTapped
            .sink { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showFourthOnboardingViewController()
            }
            .store(in: &cancelBag)
        
        return ThirdOnboardingViewModelOutput()
    }
}
