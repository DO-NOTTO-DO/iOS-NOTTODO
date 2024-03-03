//
//  UpdateCoordinatorImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

final class UpdateCoordinatorImpl: UpdateCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType { .update }
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let coordinatorFactory: CoordinatorFactory
    private let viewControllerFactory: ViewControllerFactory
    private var tabBarController: UITabBarController?
    
    required init(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
        
    }
    
    enum Constant {
        static let appstoreURL: String = "itms-apps://itunes.apple.com/app/\(Bundle.main.appleId)"
    }
    
    func start() {
        showUpdateViewController()
    }
    
    func showUpdateViewController() {
        let viewController = viewControllerFactory.makeUpdateCheckViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showUpdateAlertController() {
        let alertController = UIAlertController(
            title: I18N.update,
            message: I18N.updateAlert,
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: I18N.update, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: Constant.appstoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { [weak self] _ in
                    self?.changeMainViewController()
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: I18N.later, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: Constant.appstoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { [weak self] _ in
                    self?.changeMainViewController()
                })
            }
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        
        navigationController.present(alertController, animated: true)
    }
    
    func showForceUpdateAlertController(newVersion: String) {
        let alertController = UIAlertController(
            title: I18N.update,
            message: I18N.forceUpdateAlert(newVersion: newVersion),
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: I18N.update, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: Constant.appstoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(updateAction)
        navigationController.present(alertController, animated: true)
    }
    
    func changeMainViewController() {
        
        if KeychainUtil.getAccessToken().isEmpty {
            self.showAuthFlow()
        } else {
            self.showTabFlow()
        }
    }
    
    func showTabFlow() {
        let (tabBarController, navigationControllers) = viewControllerFactory.makeTabBarController(navigationController)
        self.tabBarController = tabBarController
        
        tabBarController.setViewControllers(navigationControllers, animated: false)
        
        let coordinators = navigationControllers.compactMap(makeTabCoordinator)
        coordinators.forEach {
            $0.delegate = self
            childCoordinators.append($0)
            $0.start()
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func showAuthFlow() {
        let authCoordinator = coordinatorFactory.makeAuthCoordinator(navigationController,
                                                                     coordinatorFactory: coordinatorFactory,
                                                                     viewControllerFactory: viewControllerFactory)
        authCoordinator.delegate = self
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }
}

// MARK: - Make TabBar

extension UpdateCoordinatorImpl {
    @discardableResult
    func makeTabCoordinator(_ navigationController: UINavigationController) -> Coordinator? {
        let tabType = TabBarItemType(rawValue: navigationController.tabBarItem.tag)
        
        switch tabType {
        case .home:
            let coordinator = coordinatorFactory.makeHomeCoordinator(
                navigationController,
                coordinatorFactory: coordinatorFactory,
                viewControllerFactory: viewControllerFactory
            )
            return coordinator
            
        case .achievement:
            let coordinator = coordinatorFactory.makeAchieveCoordinator(
                navigationController,
                coordinatorFactory: coordinatorFactory,
                viewControllerFactory: viewControllerFactory
            )
            return coordinator
            
        case .mypage:
            let coordinator = coordinatorFactory.makeMypageCoordinator(
                navigationController,
                coordinatorFactory: coordinatorFactory,
                viewControllerFactory: viewControllerFactory
            )
            return coordinator
            
        default:
            return nil
        }
    }
}

extension UpdateCoordinatorImpl: CoordinatorDelegate {
    /* update의 child로 탭바(home, mypage, achieve), auth가 존재함
     각각의 child에서 delegate?didfinish를 호출하면 여기로 호출이됨.
     delegate는 부모와 연결해주는 역할
     */
    func didFinish(childCoordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .home, .achievement, .auth:
            showTabFlow()
        case .mypage:
            showAuthFlow()
        default:
            showUpdateViewController()
        }
    }
}
