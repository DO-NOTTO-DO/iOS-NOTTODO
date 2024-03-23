//
//  AuthViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

extension ViewControllerFactoryImpl {
    func makeAuthViewController(coordinator: AuthCoordinator) -> AuthViewController {
        let viewController = AuthViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeNotificationDialogViewController(coordinator: AuthCoordinator, completion: @escaping () -> Void) -> NotificationDialogViewController {
        let viewController = NotificationDialogViewController()
        viewController.buttonHandler = {
            completion()
        }
        return viewController
    }
}

// Onboarding
extension ViewControllerFactoryImpl {
    func makeValueOnboardingViewController(coordinator: AuthCoordinator) -> ValueOnboardingViewController {
        let viewController = ValueOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeLogoOnboardingViewController(coordinator: AuthCoordinator) -> LogoOnboardingViewController {
        let viewController = LogoOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeSecondOnboardingViewController(coordinator: AuthCoordinator) -> SecondOnboardingViewController {
        let viewController = SecondOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeThirdOnboardingViewController(coordinator: AuthCoordinator) -> ThirdOnboardingViewController {
        let viewController = ThirdOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeFourthOnboardingViewController(coordinator: AuthCoordinator) -> FourthOnboardingViewController {
        let viewController = FourthOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeFifthOnboardingViewController(coordinator: AuthCoordinator) -> FifthOnboardingViewController {
        let viewController = FifthOnboardingViewController(coordinator: coordinator)
        return viewController
    }
}
