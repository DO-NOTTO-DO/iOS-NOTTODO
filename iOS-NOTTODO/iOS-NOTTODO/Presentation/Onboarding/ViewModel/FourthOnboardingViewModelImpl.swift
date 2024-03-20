//
//  FourthOnboardingViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/14/24.
//

import Combine

final class FourthOnboardingViewModelImpl: FourthOnboardingViewModel {
    
    private weak var coordinator: AuthCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: FourthOnboardingViewModelInput) -> FourthOnboardingViewModelOutput {
        input.buttonDidTapped
            .sink { [weak self] _ in
                guard let self else { return }
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext4)
                self.coordinator?.showFifthOnboardingViewController()
            }
            .store(in: &cancelBag)
        
        input.viewDidLoadSubject
            .sink {
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding4)
            }
            .store(in: &cancelBag)
        
        return FourthOnboardingViewModelOutput()
    }
}
