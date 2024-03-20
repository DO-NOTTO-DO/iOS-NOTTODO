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
            .sink { [weak self] selectList in
                guard let self else { return }
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext3(select: selectList))
                self.coordinator?.showFourthOnboardingViewController()
            }
            .store(in: &cancelBag)
        
        input.viewDidLoadSubject
            .sink {
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding3)
            }
            .store(in: &cancelBag)
        
        return ThirdOnboardingViewModelOutput()
    }
}
