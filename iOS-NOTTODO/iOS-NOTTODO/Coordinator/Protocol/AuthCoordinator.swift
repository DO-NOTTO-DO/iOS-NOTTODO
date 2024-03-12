//
//  OnboardingCoordinator.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/19/24.
//

import Foundation

protocol AuthCoordinator: Coordinator {
    func showValueOnboardingViewController()
    func showLogoOnboardingViewController()
    func showSecondOnboardingViewController()
    func showThirdOnboardingViewController()
    func showFourthOnboardingViewController()
    func showFifthOnboardingViewController()
    func connectHomeCoordinator()
    func showSignUpViewController()
    func showNotificationViewController(completion: @escaping () -> Void)
    func popViewController() 
}
