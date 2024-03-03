//
//  CoordinatorFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

/*
 CoordinatorFactory
 - description: 코디네이터 생성을 담당
 */

protocol CoordinatorFactory {}
final class CoordinatorFactoryImpl: CoordinatorFactory {}

extension CoordinatorFactory {
    func makeUpdateCoordinator(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    ) -> UpdateCoordinator {
        let coordinator = UpdateCoordinatorImpl(
            navigationController,
            coordinatorFactory: coordinatorFactory,
            viewControllerFactory: viewControllerFactory
        )
        return coordinator
    }
    
    func makeAuthCoordinator(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    ) -> AuthCoordinator {
        let coordinator = AuthCoordinatorImpl(
            navigationController,
            coordinatorFactory: coordinatorFactory,
            viewControllerFactory: viewControllerFactory
        )
        return coordinator
    }
    
    func makeHomeCoordinator(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    ) -> HomeCoordinator {
        let coordinator = HomeCoordinatorImpl(
            navigationController,
            coordinatorFactory: coordinatorFactory,
            viewControllerFactory: viewControllerFactory
        )
        return coordinator
    }
    
    func makeAchieveCoordinator(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    )
    -> AchieveCoordinator {
        let coordinator = AchieveCoordinatorImpl(
            navigationController,
            coordinatorFactory: coordinatorFactory,
            viewControllerFactory: viewControllerFactory
        )
        return coordinator
    }
    
    func makeMypageCoordinator(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    )
    -> MypageCoordinator {
        let coordinator = MypageCoordinatorImpl(
            navigationController,
            coordinatorFactory: coordinatorFactory,
            viewControllerFactory: viewControllerFactory
        )
        return coordinator
    }
}
