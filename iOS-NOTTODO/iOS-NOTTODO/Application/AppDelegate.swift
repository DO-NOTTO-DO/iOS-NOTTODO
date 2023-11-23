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
import Amplitude

import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Amplitude.instance().initializeApiKey(Bundle.main.amplitudeAPIKey)
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoAPIKey)
        FirebaseApp.configure()
        
        if KeychainUtil.getAccessToken() != "" {
            self.skipAuthView()
            print("토큰 유효")
        } else {
            // self.showAuthView()
            // 토큰이 유효하지 않을 경우 일단은 온보딩->로그인->홈 이렇게만 가도록
        }
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true
        
        // 푸시 알림 권한 설정 및 푸시 알림에 앱 등록
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        
        // device token 요청.
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func showAuthView() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let authViewController = AuthViewController()
                let navigationController = UINavigationController(rootViewController: authViewController)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func skipAuthView() {
        // 홈 화면으로 바로 이동
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let tabBarController = NotificationDialogViewController()
                let navigationController = UINavigationController(rootViewController: tabBarController)
                navigationController.isNavigationBarHidden = true
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
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

extension AppDelegate: MessagingDelegate {
    /// 현재 등록 토큰 가져오기.
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            if let fcmToken = fcmToken {
                KeychainUtil.setFcmToken(fcmToken)
            }
        }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    /// foreground에서 러닝 중에 앱에 도착하는 알림을 다루는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .sound, .badge, .banner])
    }

    /// 도착한 notification에 대한 유저의 반응을 다루는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
