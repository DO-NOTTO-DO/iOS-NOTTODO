//
//  ViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

protocol ViewControllerFactory: UpdateFlowcontrollerFactory, AuthFlowControllerFactory, HomeFlowControllerFactory, MyPageFlowControllerFactory, AchieveFlowControllerFactory, TabBarControllerFactory, AuthFlowControllerFactory {}

protocol UpdateFlowcontrollerFactory {
    func makeUpdateCheckViewController(coordinator: UpdateCoordinator) -> UpdateCheckViewController
}

protocol AuthFlowControllerFactory {
    func makeValueOnboardingViewController(coordinator: AuthCoordinator) -> ValueOnboardingViewController
    func makeLogoOnboardingViewController(coordinator: AuthCoordinator) -> LogoOnboardingViewController
    func makeSecondOnboardingViewController(coordinator: AuthCoordinator) -> SecondOnboardingViewController
    func makeThirdOnboardingViewController(coordinator: AuthCoordinator) -> ThirdOnboardingViewController
    func makeFourthOnboardingViewController(coordinator: AuthCoordinator) -> FourthOnboardingViewController
    func makeFifthOnboardingViewController(coordinator: AuthCoordinator) -> FifthOnboardingViewController
    func makeAuthViewController(coordinator: AuthCoordinator) -> AuthViewController
    func makeNotificationDialogViewController(coordinator: AuthCoordinator, completion: @escaping () -> Void) -> NotificationDialogViewController
    
}

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

protocol MyPageFlowControllerFactory {
    func makeMyInfoViewController(coordinator: MypageCoordinator) -> MyInfoViewController
    func makeMyInfoAccountViewController(coordinator: MypageCoordinator) -> MyInfoAccountViewController
    func makeWithdrawViewController(coordinator: MypageCoordinator) -> NottodoModalViewController
}

protocol AchieveFlowControllerFactory {
    func makeAchieveViewController(coordinator: AchieveCoordinator) -> AchievementViewController
    func makeAchieveDetailViewController(coordinator: AchieveCoordinator, date: Date) -> DetailAchievementViewController
}

protocol TabBarControllerFactory {
    func makeTabBarController(_ navigationController: UINavigationController) -> (UITabBarController, [UINavigationController])
}

final class ViewControllerFactoryImpl: ViewControllerFactory {}

// update
extension ViewControllerFactoryImpl {
    func makeUpdateCheckViewController(coordinator: UpdateCoordinator) -> UpdateCheckViewController {
        let viewController = UpdateCheckViewController(coordinator: coordinator)
        return viewController
    }
}
// onboarding
extension ViewControllerFactoryImpl {
    func makeValueOnboardingViewController(coordinator: AuthCoordinator) -> ValueOnboardingViewController {
        let viewModel = ValueOnboardingViewModelImpl(coordinator: coordinator)
        let viewController = ValueOnboardingViewController(viewModel: viewModel)
        return viewController
    }
    func makeLogoOnboardingViewController(coordinator: AuthCoordinator) -> LogoOnboardingViewController {
        let viewModel = LogoOnboardingViewModelImpl(coodinator: coordinator)
        let viewController = LogoOnboardingViewController(viewModel: viewModel)
        return viewController
    }
    func makeSecondOnboardingViewController(coordinator: AuthCoordinator) -> SecondOnboardingViewController {
        let viewModel = SecondOnboardingViewModelImpl(coordinator: coordinator)
        let viewController = SecondOnboardingViewController(viewModel: viewModel)
        return viewController
    }
    func makeThirdOnboardingViewController(coordinator: AuthCoordinator) -> ThirdOnboardingViewController {
        let viewController = ThirdOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeFourthOnboardingViewController(coordinator: AuthCoordinator) -> FourthOnboardingViewController {
        let viewController = FourthOnboardingViewController(coordinator: coordinator)
        return viewController
    }
    func makeFifthOnboardingViewController(coordinator: AuthCoordinator) -> FifthOnboardingViewController {
        let viewController = FifthOnboardingViewController(coordinator: coordinator)
        return viewController
    }
}
// auth
extension ViewControllerFactoryImpl {
    func makeAuthViewController(coordinator: AuthCoordinator) -> AuthViewController {
        let viewController = AuthViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeNotificationDialogViewController(coordinator: AuthCoordinator, completion: @escaping () -> Void) -> NotificationDialogViewController {
        let viewController = NotificationDialogViewController()
        viewController.buttonHandler = {
            completion()
        }
        return viewController
    }
}
// home
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

// add mission
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
// home detail
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
// mypage
extension ViewControllerFactoryImpl {
    func makeMyInfoViewController(coordinator: MypageCoordinator) -> MyInfoViewController {
        let viewController = MyInfoViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeMyInfoAccountViewController(coordinator: MypageCoordinator) -> MyInfoAccountViewController {
        let viewController = MyInfoAccountViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeWithdrawViewController(coordinator: MypageCoordinator) -> NottodoModalViewController {
        let viewController = NottodoModalViewController(coordinator: coordinator)
        return viewController
    }
}
// achieve
extension ViewControllerFactoryImpl {
    func makeAchieveViewController(coordinator: AchieveCoordinator) -> AchievementViewController {
        let viewController = AchievementViewController(coordinator: coordinator)
        return viewController
    }
    
    func makeAchieveDetailViewController(coordinator: AchieveCoordinator, date: Date) -> DetailAchievementViewController {
        let viewController = DetailAchievementViewController(coordinator: coordinator)
        viewController.selectedDate = date
        return viewController
    }
}
// tabbar
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
