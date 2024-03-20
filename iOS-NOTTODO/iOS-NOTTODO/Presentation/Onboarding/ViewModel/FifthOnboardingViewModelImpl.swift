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
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext5)
                self.coordinator?.showSignUpViewController()
            }
            .store(in: &cancelBag)
        
        input.viewDidLoadSubject
            .sink {
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding5)
            }
            .store(in: &cancelBag)
        
        return FifthOnboardingViewModelOutput()
    }
}
