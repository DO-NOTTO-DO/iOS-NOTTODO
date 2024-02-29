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
    func showLogoutAlertController(completion: @escaping () -> Void) // action button 클릭시 이벤트
    func connectAuthCoordinator(type: ViewType) // type에 따라서 userdefault 비워줌 
}
