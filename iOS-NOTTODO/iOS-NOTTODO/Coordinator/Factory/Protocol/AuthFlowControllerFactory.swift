//
//  AuthFlowControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation
protocol AuthFlowControllerFactory {
    func makeValueOnboardingViewController(coordinator: AuthCoordinator) -> ValueOnboardingViewController
    func makeLogoOnboardingViewController(coordinator: AuthCoordinator) -> LogoOnboardingViewController
    func makeSecondOnboardingViewController(coordinator: AuthCoordinator) -> SecondOnboardingViewController
    func makeThirdOnboardingViewController(coordinator: AuthCoordinator) -> ThirdOnboardingViewController
    func makeFourthOnboardingViewController(coordinator: AuthCoordinator) -> FourthOnboardingViewController
    func makeFifthOnboardingViewController(coordinator: AuthCoordinator) -> FifthOnboardingViewController
    func makeAuthViewController(coordinator: AuthCoordinator) -> AuthViewController
    func makeNotificationDialogViewController(coordinator: AuthCoordinator, completion: @escaping () -> Void) -> NotificationDialogViewController
}
