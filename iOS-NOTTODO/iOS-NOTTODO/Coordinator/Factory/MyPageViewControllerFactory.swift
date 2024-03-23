//
//  MyPageViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

extension ViewControllerFactoryImpl {
    
    func makeMyPageManager() -> MyPageManger {
        let authAPI = DefaultAuthService()
        let manager = MyPageManagerImpl(authAPI: authAPI)
        return manager
    }
    
    func makeMyPageViewModel(coordinator: MypageCoordinator) -> any MyPageViewModel {
        let viewModel = MyPageViewModelImpl(coordinator: coordinator)
        return viewModel
    }
    
    func makeMyPageViewController(coordinator: MypageCoordinator) -> MyPageViewController {
        let viewModel = self.makeMyPageViewModel(coordinator: coordinator)
        let viewController = MyPageViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeMyPageAccountViewModel(coordinator: MypageCoordinator) -> any MyPageAccountViewModel {
        let manager = self.makeMyPageManager()
        let viewModel = MyPageAccountViewModelImpl(coordinator: coordinator, manager: manager)
        return viewModel
    }
    
    func makeMyPageAccountViewController(coordinator: MypageCoordinator) -> MyPageAccountViewController {
        let viewModel = self.makeMyPageAccountViewModel(coordinator: coordinator)
        let viewController = MyPageAccountViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeWithdrawViewModel(coordinator: MypageCoordinator) -> any ModalViewModel {
        let manager = self.makeMyPageManager()
        let viewModel = ModalViewModelImpl(coordinator: coordinator, manager: manager)
        return viewModel
    }
    
    func makeWithdrawViewController(coordinator: MypageCoordinator) -> NottodoModalViewController {
        let viewModel = self.makeWithdrawViewModel(coordinator: coordinator)
        let viewController = NottodoModalViewController(viewModel: viewModel)
        return viewController
    }
}
