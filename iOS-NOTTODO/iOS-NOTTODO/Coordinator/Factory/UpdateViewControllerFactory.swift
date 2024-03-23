//
//  UpdateViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

extension ViewControllerFactoryImpl {
    func makeUpdateCheckViewController(coordinator: UpdateCoordinator) -> UpdateCheckViewController {
        let viewController = UpdateCheckViewController(coordinator: coordinator)
        return viewController
    }
}
