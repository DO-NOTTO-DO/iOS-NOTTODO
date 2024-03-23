//
//  HomeViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

// Home
extension ViewControllerFactoryImpl {
    func makePopupViewController(coordinator: HomeCoordinator, completion: @escaping () -> Void) -> CommonNotificationViewController {
        let viewController = CommonNotificationViewController(coordinator: coordinator)
        viewController.tapCloseButton = {
            completion()
        }
        return viewController
    }
    
    func makeHomeViewController(coordinator: HomeCoordinator) -> HomeViewController {
        let viewController = HomeViewController(coordinator: coordinator)
        return viewController
    }
}

// HomeDetail
extension ViewControllerFactoryImpl {
    func makeDeleteViewController(coordinator: HomeCoordinator, completion: @escaping () -> Void) -> HomeDeleteViewController {
        let viewController = HomeDeleteViewController(coordinator: coordinator)
        viewController.deleteClosure = {
            completion()
        }
        return viewController
    }
    
    func makeMissionDetailViewController(coordinator: HomeCoordinator, id: Int, deleteClosure: @escaping () -> Void, moveDateClosure: @escaping (String) -> Void) -> MissionDetailViewController {
        let viewController = MissionDetailViewController(coordinator: coordinator)
        viewController.userId = id
        viewController.deleteClosure = {
            deleteClosure()
        }
        viewController.moveDateClosure = { date in
            moveDateClosure(date)
        }
        return viewController
    }
    
    func makeModifyViewController(coordinator: HomeCoordinator, id: Int = 0, type: MissionType) -> AddMissionViewController {
        let viewController = AddMissionViewController(coordinator: coordinator)
        viewController.setViewType(type)
        viewController.setMissionId(id)
        return viewController
    }
    
    func makeSelectDateViewController(coordinator: HomeCoordinator, data: MissionDetailResponseDTO, id: Int, moveDateClosure: @escaping (String) -> Void) -> DetailCalendarViewController {
        let viewController = DetailCalendarViewController(coordinator: coordinator)
        viewController.detailModel = data
        viewController.userId = id
        viewController.movedateClosure = { date in
            moveDateClosure(date)
        }
        return viewController
    }
}

// Add Mission
extension ViewControllerFactoryImpl {
    
    func makeRecommendViewController(coordinator: HomeCoordinator, date: String) -> RecommendViewController {
        let viewController = RecommendViewController(coordinator: coordinator)
        viewController.setSelectDate(date)
        return viewController
    }
    
    func makeRecommendDetailViewController(coordinator: HomeCoordinator, data: RecommendActionData) -> RecommendActionViewController {
        let viewController = RecommendActionViewController(coordinator: coordinator)
        viewController.actionHeaderData = data
        return viewController
    }
    
    func makeAddViewController(coordinator: HomeCoordinator, data: AddMissionData, type: MissionType) -> AddMissionViewController {
        let viewController = AddMissionViewController(coordinator: coordinator)
        viewController.setViewType(type)
        viewController.setNottodoLabel(data.nottodo ?? "")
        viewController.setSituationLabel(data.situation ?? "")
        viewController.setActionLabel(data.action ?? "")
        viewController.setDate(data.date)
        
        return viewController
    }
}
