//
//  AppCoordinatorImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

final class AppCoordinatorImpl: NSObject, AppCoordinator {
    weak var delegate: CoordinatorDelegate?
    var type: CoordinatorType { .app }
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
    
    func start() {
        showUpdateFlow()
    }
    
    func showUpdateFlow() {
        let updateCoordinator = coordinatorFactory.makeUpdateCoordinator(navigationController,
                                                                         coordinatorFactory: coordinatorFactory,
                                                                         viewControllerFactory: viewControllerFactory)
        updateCoordinator.delegate = self
        updateCoordinator.start()
        childCoordinators.append(updateCoordinator)
    }
}

extension AppCoordinatorImpl: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()
    }
}
