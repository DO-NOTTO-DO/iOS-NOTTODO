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
            .sink { [weak self] indexPath in
                guard let self else { return }
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext2(select: SecondOnboardingModel.titles[indexPath.row].title))
                self.coordinator?.showThirdOnboardingViewController()
            }
            .store(in: &cancelBag)
        
        input.viewDidLoadSubject
            .sink {
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding2)
            }
            .store(in: &cancelBag)
        
        return SecondOnboardingViewModelOutput()
    }
}
