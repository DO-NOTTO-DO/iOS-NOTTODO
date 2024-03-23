//
//  MyPageFlowControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

protocol MyPageFlowControllerFactory {
    func makeMyInfoViewController(coordinator: MypageCoordinator) -> MyInfoViewController
    func makeMyInfoAccountViewController(coordinator: MypageCoordinator) -> MyInfoAccountViewController
    func makeWithdrawViewController(coordinator: MypageCoordinator) -> NottodoModalViewController
}
