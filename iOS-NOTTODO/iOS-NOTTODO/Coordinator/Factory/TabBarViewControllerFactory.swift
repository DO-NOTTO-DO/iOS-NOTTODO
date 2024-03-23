//
//  TabBarViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import UIKit

extension ViewControllerFactoryImpl {
    func makeTabBarController(_: UINavigationController) -> (UITabBarController, [UINavigationController]) {
        let tabBarController = TabBarController()
        let navigationControllers = tabBarController.setTabBarItems().map(makeNavigationController)
        
        return (tabBarController, navigationControllers)
    }
    
    func makeNavigationController(_ tabBarItem: UITabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabBarItem
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}
