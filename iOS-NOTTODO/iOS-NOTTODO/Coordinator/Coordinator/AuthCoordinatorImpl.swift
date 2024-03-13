//
//  OnboardingCoordinatorImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/19/24.
//

import UIKit

final class AuthCoordinatorImpl: AuthCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType { .auth }
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let coordinatorFactory: CoordinatorFactory
    private let viewControllerFactory: ViewControllerFactory
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(popToRoot),
            name: NotificationCenterKey.refreshTokenHasExpired,
            object: nil
        )
    }
    
    func start() {
        if KeychainUtil.getAccessToken().isEmpty {
            showValueOnboardingViewController()
        } else {
            showSignUpViewController()
        }
    }
    
    func showValueOnboardingViewController() {
        let viewController = viewControllerFactory.makeValueOnboardingViewController(coordinator: self)
        changeAnimation()
        navigationController.setViewControllers([viewController], animated: false) // 루트 뷰 컨트롤러 설정
    }
    
    func showLogoOnboardingViewController() {
        let viewController = viewControllerFactory.makeLogoOnboardingViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: false) // value -> logo
    }
    
    func showSecondOnboardingViewController() {
        let viewController = viewControllerFactory.makeSecondOnboardingViewController(coordinator: self)
        changeAnimation()
        navigationController.pushViewController(viewController, animated: false) // logo -> second
    }
    
    func showThirdOnboardingViewController() {
        let viewController = viewControllerFactory.makeThirdOnboardingViewController(coordinator: self)
        changeAnimation()
        navigationController.pushViewController(viewController, animated: false) // logo -> third
    }
    
    func showFourthOnboardingViewController() {
        let viewController = viewControllerFactory.makeFourthOnboardingViewController(coordinator: self)
        changeAnimation()
        navigationController.pushViewController(viewController, animated: false) // third -> fourth
    }
    
    func showFifthOnboardingViewController() {
        let viewController = viewControllerFactory.makeFifthOnboardingViewController(coordinator: self)
        changeAnimation()
        navigationController.pushViewController(viewController, animated: false) // fourth -> fifth
    }
    
    func showSignUpViewController() { // fifth -> root 변경 -> signup
        let viewController = viewControllerFactory.makeAuthViewController(coordinator: self)
        changeAnimation()
        navigationController.setViewControllers([viewController], animated: false) // 루트 뷰 컨트롤러 설정
    }
    
    func showNotificationViewController(completion: @escaping () -> Void) {
        let viewController = viewControllerFactory.makeNotificationDialogViewController(coordinator: self, completion: completion)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func connectHomeCoordinator() {
        navigationController.dismiss(animated: true) { [unowned self] in
            finish()
        }
    }
    
    @objc
    func popToRoot(_ notification: Notification) {
        showSignUpViewController()
    }
}
