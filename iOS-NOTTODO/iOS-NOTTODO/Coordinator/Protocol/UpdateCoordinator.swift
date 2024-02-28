//
//  UpdateCoordinator.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import Foundation

protocol UpdateCoordinator: Coordinator {
    func showUpdateViewController()
    func showTabFlow(to tab: TabBarItemType)
    func showAuthFlow()
}
