//
//  HomecoordinatorImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

final class HomeCoordinatorImpl: HomeCoordinator {
    
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var recommendNavigationController: UINavigationController = .init()
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .home }
    
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
        showHomeViewController()
    }
    
    func showPopupViewController(completion: @escaping () -> Void) {
        let viewController = viewControllerFactory.makePopupViewController(coordinator: self, completion: completion)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
    }
    
    func showHomeViewController() {
        let viewController = viewControllerFactory.makeHomeViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showMissionDetailViewController(id: Int, deleteClosure: @escaping () -> Void, moveDateClosure: @escaping (String) -> Void) {
        let viewController = viewControllerFactory.makeMissionDetailViewController(coordinator: self, id: id, deleteClosure: deleteClosure, moveDateClosure: moveDateClosure)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true)
    }
    
    func showSelectDateViewController(data: MissionDetailResponseDTO, id: Int, moveDateClosure: @escaping (String) -> Void) {
        if let presentedViewController = navigationController.presentedViewController {
            let viewController = viewControllerFactory.makeSelectDateViewController(coordinator: self, data: data, id: id, moveDateClosure: moveDateClosure)
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            presentedViewController.present(viewController, animated: false)
        }
    }
    
    func showModifyViewController(id: Int, type: MissionType) {
        self.dismiss()
        let viewController = viewControllerFactory.makeModifyViewController(coordinator: self, id: id, type: type)
        viewController.modalPresentationStyle = .fullScreen // view will appear 동작
        navigationController.present(viewController, animated: true)
    }
    
    func showAddViewController(data: AddMissionData, type: MissionType) {
        self.dismiss()
        let viewController = viewControllerFactory.makeAddViewController(coordinator: self, data: data, type: type)
        viewController.modalPresentationStyle = .fullScreen // view will appear 동작
        navigationController.present(viewController, animated: true)
    }
    
    func showRecommendViewController(selectedDate: String) {
        let viewController = viewControllerFactory.makeRecommendViewController(coordinator: self, date: selectedDate)
        let recommendNavigationController = UINavigationController(rootViewController: viewController)
        recommendNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(recommendNavigationController, animated: true)
        self.recommendNavigationController = recommendNavigationController
    }
    
    func showRecommendDetailViewController(actionData: RecommendActionData) {
        let viewController = viewControllerFactory.makeRecommendDetailViewController(coordinator: self, data: actionData)
        viewController.modalPresentationStyle = .fullScreen
        recommendNavigationController.navigationBar.isHidden = true
        recommendNavigationController.pushViewController(viewController, animated: true)
    }
    
    func showDeleteViewController(completion: @escaping () -> Void) {
        let presentedViewController = navigationController.presentedViewController != nil ? navigationController.presentedViewController : navigationController
        let viewController = viewControllerFactory.makeDeleteViewController(coordinator: self, completion: completion)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        presentedViewController?.present(viewController, animated: true)
    }
    
    func dismissLastPresentedViewController() {
        let presentedViewController = navigationController.presentedViewController != nil ? navigationController.presentedViewController : navigationController
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension HomeCoordinatorImpl {
    func popViewController() {
        recommendNavigationController.popViewController(animated: true)
    }
}
