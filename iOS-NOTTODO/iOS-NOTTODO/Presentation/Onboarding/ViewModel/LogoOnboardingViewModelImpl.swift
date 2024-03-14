//
//  LogoOnboardingViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

final class LogoOnboardingViewModelImpl: LogoOnboardingViewModel {
    
    private weak var coodinator: AuthCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coodinator: AuthCoordinator) {
        self.coodinator = coodinator
    }
    
    func transform(input: LogoOnboardingViewModelInput) -> LogoOnboardingViewModelOutput {
        input.startButtonTappedSubject
            .sink { [weak self] _ in
                self?.coodinator?.showSecondOnboardingViewController()
            }
            .store(in: &cancelBag)
        
        return LogoOnboardingViewModelOutput()
    }
}
