//
//  AchieveCoordinator.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import Foundation

protocol AchieveCoordinator: Coordinator {
    func showAchieveViewController()
    func showAchieveDetailViewController(selectedDate: Date)
}
