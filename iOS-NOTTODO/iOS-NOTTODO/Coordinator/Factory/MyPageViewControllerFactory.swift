//
//  MyPageViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

extension ViewControllerFactoryImpl {
    func makeMyInfoViewController(coordinator: MypageCoordinator) -> MyInfoViewController {
        let viewController = MyInfoViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeMyInfoAccountViewController(coordinator: MypageCoordinator) -> MyInfoAccountViewController {
        let viewController = MyInfoAccountViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeWithdrawViewController(coordinator: MypageCoordinator) -> NottodoModalViewController {
        let viewController = NottodoModalViewController(coordinator: coordinator)
        return viewController
    }
}
