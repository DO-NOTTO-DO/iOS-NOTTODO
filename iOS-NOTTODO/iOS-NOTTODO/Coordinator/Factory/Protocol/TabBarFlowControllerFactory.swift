//
//  TabBarFlowControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import UIKit

protocol TabBarControllerFactory {
    func makeTabBarController(_ navigationController: UINavigationController) -> (UITabBarController, [UINavigationController])
}
