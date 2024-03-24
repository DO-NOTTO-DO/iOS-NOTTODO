//
//  MypageCoordinatorImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

final class MypageCoordinatorImpl: MypageCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType { .mypage }
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let coordinatorFactory: CoordinatorFactory
    private let viewControllerFactory: ViewControllerFactory
    
    required init(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        showMyInfoViewController()
    }
    
    func showMyInfoViewController() {
        let viewController = viewControllerFactory.makeMyPageViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showMyInfoAccountViewController() {
        let viewController = viewControllerFactory.makeMyPageAccountViewController(coordinator: self)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showWithdrawViewController() {
        let viewController = viewControllerFactory.makeWithdrawViewController(coordinator: self)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true)
    }
    
    func showLogoutAlertController(completion: @escaping () -> Void) {
        let logoutAlert = UIAlertController(title: I18N.logoutAlertTitle, message: I18N.logoutAlertmessage, preferredStyle: UIAlertController.Style.alert)
        let logoutAction = UIAlertAction(title: I18N.logout, style: UIAlertAction.Style.default, handler: { _ in
            completion()
        })
        let cancelAlert = UIAlertAction(title: I18N.cancel, style: UIAlertAction.Style.default, handler: nil)
        logoutAlert.addAction(cancelAlert)
        logoutAlert.addAction(logoutAction)
        navigationController.present(logoutAlert, animated: true)
    }

    func connectAuthCoordinator(type: ViewType) {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.finish()
            switch type {
            case .quitSurvey:
                KeychainUtil.removeUserInfo()
            case .logout:
                UserDefaults.standard.removeObject(forKey: DefaultKeys.accessToken)
                UserDefaults.standard.removeObject(forKey: DefaultKeys.socialToken)
            default:
                break
            }
        }
    }
}
