//
//  MypageCoordinator.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import Foundation

protocol MypageCoordinator: Coordinator {
    func showMyInfoViewController()
    func showMyInfoAccountViewController()
    func showWithdrawViewController()
    func showLogoutAlertController(completion: @escaping () -> Void)
    func connectAuthCoordinator()
    func finish()
}
