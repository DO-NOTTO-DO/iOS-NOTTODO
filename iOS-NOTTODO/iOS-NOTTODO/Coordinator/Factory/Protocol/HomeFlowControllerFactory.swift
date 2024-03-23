//
//  HomeFlowControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

protocol HomeFlowControllerFactory {
    func makePopupViewController(coordinator: HomeCoordinator, completion: @escaping () -> Void) -> CommonNotificationViewController
    func makeHomeViewController(coordinator: HomeCoordinator) -> HomeViewController
    func makeRecommendViewController(coordinator: HomeCoordinator, date: String) -> RecommendViewController
    func makeRecommendDetailViewController(coordinator: HomeCoordinator, data: RecommendActionData) -> RecommendActionViewController
    func makeAddViewController(coordinator: HomeCoordinator, data: AddMissionData, type: MissionType) -> AddMissionViewController
    func makeDeleteViewController(coordinator: HomeCoordinator, completion: @escaping () -> Void) -> HomeDeleteViewController
    func makeMissionDetailViewController(coordinator: HomeCoordinator, id: Int, deleteClosure: @escaping () -> Void, moveDateClosure: @escaping (String) -> Void) -> MissionDetailViewController
    func makeModifyViewController(coordinator: HomeCoordinator, id: Int, type: MissionType) -> AddMissionViewController
    func makeSelectDateViewController(coordinator: HomeCoordinator, data: MissionDetailResponseDTO, id: Int, moveDateClosure: @escaping (String) -> Void) -> DetailCalendarViewController
}
