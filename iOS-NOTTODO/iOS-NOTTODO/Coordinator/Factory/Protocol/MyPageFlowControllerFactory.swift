//
//  MyPageFlowControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

protocol MyPageFlowControllerFactory {
    func makeMyPageViewController(coordinator: MypageCoordinator) -> MyPageViewController
    func makeMyPageAccountViewController(coordinator: MypageCoordinator) -> MyPageAccountViewController
    func makeWithdrawViewController(coordinator: MypageCoordinator) -> NottodoModalViewController
}
