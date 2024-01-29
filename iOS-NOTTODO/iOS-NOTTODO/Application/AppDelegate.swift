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
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Amplitude.instance().initializeApiKey(Bundle.main.amplitudeAPIKey)
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoAPIKey)
        FirebaseApp.configure()
    
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true

        // device token 요청.
        application.registerForRemoteNotifications()
        
        return true
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
