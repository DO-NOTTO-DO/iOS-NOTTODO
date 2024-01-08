//
//  SceneDelegate.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    static var shared: SceneDelegate? { UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
            
            let rootViewController = ValueOnboardingViewController()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.isNavigationBarHidden = true
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

extension SceneDelegate {
    
    func changeRootViewControllerTo(_ viewController: UIViewController) {
        guard let window = window else { return }
        
        let rootViewController = viewController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
    }
}
