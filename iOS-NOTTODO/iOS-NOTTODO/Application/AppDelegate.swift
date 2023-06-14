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
        
//        if UserDefaults.standard.string(forKey: "KakaoAccessToken") != nil {
//            UserApi.shared.accessTokenInfo { (_, error) in
//                if let _ = error {
//                    // 카카오 로그인 정보가 유효하지 않은 경우
//                    self.checkAppleLoginStatus()
//                } else {
//                    // 카카오 로그인 정보가 유효한 경우
//                    self.skipAuthView()
//                }
//            }
//        } else {
//            // 카카오 로그인 정보가 없는 경우
//            checkAppleLoginStatus()
//        }

        return true
    }

//    func checkAppleLoginStatus() {
//        if UserDefaults.standard.bool(forKey: "isAppleLogin") {
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: "AppleAccessToken") ?? "") { credentialState, _ in
//                switch credentialState {
//                case .authorized:
//                    // 애플 로그인 정보가 유효한 경우
//                    self.skipAuthView()
//                case .revoked, .notFound:
//                    // 애플 로그인 정보가 유효하지 않은 경우
//                    self.showAuthView()
//                default:
//                    break
//                }
//            }
//        } else {
//            // 애플 로그인 정보가 없는 경우
//            showAuthView()
//        }
//    }
//
//    func showAuthView() {
//        DispatchQueue.main.async {
//            let authViewController = AuthViewController()
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = authViewController
//            self.window?.makeKeyAndVisible()
//        }
//    }
//
//    func skipAuthView() {
//        // 홈 화면으로 바로 이동
//        DispatchQueue.main.async {
//            let homeViewController = HomeViewController()
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = homeViewController
//            self.window?.makeKeyAndVisible()
//        }
//    }
}

// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
}
