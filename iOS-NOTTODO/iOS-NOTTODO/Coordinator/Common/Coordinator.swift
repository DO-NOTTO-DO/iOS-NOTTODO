//
//  Coordinator.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var delegate: CoordinatorDelegate? { get set }
    var type: CoordinatorType { get }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    
    init(
        _ navigationController: UINavigationController,
        coordinatorFactory: CoordinatorFactory,
        viewControllerFactory: ViewControllerFactory
    )
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
        debugPrint(childCoordinators)
    }
    
    func changeAnimation() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if let window {
            UIView.transition(
                with: window,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
    }
    
    // MARK: - pop/dismiss는 공통으로 추출
    
    /*
     현재 UINavigationController의 스택에서 가장 아래에 있는 루트뷰 컨트롤러까지 모든 뷰 컨트롤러를 제거하고,
     루트 뷰 컨트롤러를 화면에 표시하는 역할
     */
    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
