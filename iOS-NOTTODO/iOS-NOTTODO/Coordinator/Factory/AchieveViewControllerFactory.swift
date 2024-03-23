//
//  AchieveViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

extension ViewControllerFactoryImpl {
    
    func makeAchieveViewModel(coordinator: AchieveCoordinator) -> any AchievementViewModel {
        let missionAPI = DefaultMissionService()
        let manager = AchieveManagerImpl(missionAPI: missionAPI)
        let viewModel = AchievementViewModelImpl(coordinator: coordinator, manager: manager)
        return viewModel
    }
    
    func makeAchieveViewController(coordinator: AchieveCoordinator) -> AchievementViewController {
        let viewModel = self.makeAchieveViewModel(coordinator: coordinator)
        let viewController = AchievementViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeAchieveDetailViewModel(coordinator: AchieveCoordinator) -> any DetailAchievementViewModel & DetailAchievementViewModelPresentable {
        let missionAPI = DefaultMissionService()
        let manager = AchieveManagerImpl(missionAPI: missionAPI)
        let viewModel = DetailAchievementViewModelImpl(coordinator: coordinator, manager: manager)
        return viewModel
    }
    
    func makeAchieveDetailViewController(coordinator: AchieveCoordinator, date: String) -> DetailAchievementViewController {
        let viewModel = self.makeAchieveDetailViewModel(coordinator: coordinator)
        viewModel.selectedDate(date)
        let viewController = DetailAchievementViewController(viewModel: viewModel)
        return viewController
    }
}
