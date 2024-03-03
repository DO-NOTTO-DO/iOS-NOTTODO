//
//  HomeCoordinator.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import Foundation

protocol HomeCoordinator: Coordinator {
    func showHomeViewController()
    func showPopupViewController(completion: @escaping () -> Void)
    func showMissionDetailViewController(id: Int, deleteClosure: @escaping () -> Void, moveDateClosure: @escaping (String) -> Void) 
    func showSelectDateViewController(data: MissionDetailResponseDTO, id: Int, moveDateClosure: @escaping (String) -> Void) 
    func showModifyViewController(id: Int, type: MissionType)
    func showAddViewController(data: AddMissionData, type: MissionType)
    func showRecommendViewController(selectedDate: String)
    func showRecommendDetailViewController(actionData: RecommendActionData)
    func showDeleteViewController(completion: @escaping () -> Void)
    func popViewController()
    func dismissRecommendViewcontroller()
    func dismissLastPresentedViewController()
}
