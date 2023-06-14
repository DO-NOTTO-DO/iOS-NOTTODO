//
//  AppDelegate.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDK.initSDK(appKey: "f06c671df540ff4a8f8275f453368748")
        
        if KeychainUtil.getSocialToken() != "" {
            self.skipAuthView()
            print("토큰유효!!!!!")
        } else {
            // self.showAuthView()
            // 토큰이 유효하지 않을 경우 일단은 온보딩->로그인->홈 이렇게 가도록
            print("토큰없넹!!!!!")
        }
        return true
    }
    
    func showAuthView() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let authViewController = AuthViewController()
                window.rootViewController = authViewController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func skipAuthView() {
        // 홈 화면으로 바로 이동
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let tabBarController = TabBarController()
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }
}

// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
}
