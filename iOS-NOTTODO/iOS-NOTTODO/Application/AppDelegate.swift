//
//  AppDelegate.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var isLogin = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDK.initSDK(appKey: "6f841a6d67d26f443d42124882524e1f")
        
//        let accessToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken)
//
//        if accessToken != nil {
//            if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.isAppleLogin) {
//                // 애플 로그인으로 연동되어 있을 때 애플 ID와의 연동상태 확인
//                let appleIDProvider = ASAuthorizationAppleIDProvider()
//                appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "") { credentialState, _ in
//                    switch credentialState {
//                    case .authorized:
//                        print("해당 ID는 연동되어있습니다.")
//                        self.isLogin = true
//                    case .revoked:
//                        print("해당 ID는 연동되어있지않습니다.")
//                        self.isLogin = false
//                    case .notFound:
//                        print("해당 ID를 찾을 수 없습니다.")
//                        self.isLogin = false
//                    default:
//                        break
//                    }
//                }
//            } else {
//                if AuthApi.hasToken() {
//                    UserApi.shared.accessTokenInfo { _, error in
//                        if let error = error {
//                            if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
//                                self.isLogin = false
//                            }
//                        } else {
//                            // 토큰 유효성 확인한 경우
//                            self.isLogin = true
//                        }
//                    }
//                } else {
//                    // 유효한 토큰이 없는 경우
//                    self.isLogin = false
//                }
//            }
//        } else {
//            // access token 이 없는 경우
//            self.isLogin = false
//        }
        
        return true
    }
}

// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
}
