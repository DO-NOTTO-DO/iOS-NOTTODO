//
//  AchieveCoordinatorImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

final class AchieveCoordinatorImpl: AchieveCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .achievement }
    
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
        showAchieveViewController()
    }
    
    func showAchieveViewController() {
        let viewController = viewControllerFactory.makeAchieveViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showAchieveDetailViewController(selectedDate: Date) {
        let viewController = viewControllerFactory.makeAchieveDetailViewController(coordinator: self, date: selectedDate)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: false)
    }
}
