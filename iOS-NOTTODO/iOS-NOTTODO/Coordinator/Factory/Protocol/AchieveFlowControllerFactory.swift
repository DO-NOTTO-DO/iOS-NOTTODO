//
//  AchieveFlowControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

protocol AchieveFlowControllerFactory {
    func makeAchieveViewController(coordinator: AchieveCoordinator) -> AchievementViewController
    func makeAchieveDetailViewController(coordinator: AchieveCoordinator, date: String) -> DetailAchievementViewController
}
