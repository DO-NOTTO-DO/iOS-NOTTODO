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
        
        checkForUpdate()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true

        // device token 요청.
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func skipAuthView() {
        // 홈 화면으로 바로 이동
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let tabBarController = TabBarController()
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

extension AppDelegate {
    func checkForUpdate() {
        // 앱스토어 버전
        guard let appstoreVersion = getAppstoreVersion() else { return }
        
        // 현재 설치된 앱의 버전
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        if compareVersion(userVersion: appVersion, appstoreVersion: appstoreVersion) {
            DispatchQueue.main.async {
                self.showUpdateAlert()
            }
        } else {
            if KeychainUtil.getAccessToken() != "" {
                self.skipAuthView()
                print("토큰 유효")
            }
        }
    }
    
    /// 버전 비교하는 메서드
    func compareVersion(userVersion: String, appstoreVersion: String) -> Bool {
        let userMajor = userVersion.split(separator: ".").map {Int($0)!}[0]
        let appstoreMajor = appstoreVersion.split(separator: ".").map {Int($0)!}[0]
        
        if userMajor < appstoreMajor {
            return true
        }
        
        let userMinor = userVersion.split(separator: ".").map {Int($0)!}[1]
        let appstoreMinor = appstoreVersion.split(separator: ".").map {Int($0)!}[1]
        
        if userMinor < appstoreMinor {
            return true
        }
        
        let userPatch = userVersion.split(separator: ".").map {Int($0)!}[2]
        let appstorePatch = appstoreVersion.split(separator: ".").map {Int($0)!}[2]
        
        if userPatch < appstorePatch {
            return true
        }
        
        return false
    }
    
    /// 앱스토어에 배포된 버전 가져오는 메서드
    func getAppstoreVersion() -> String? {
        let appleID = Bundle.main.appleId
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    /// 선택 업데이트 경고창
    func showUpdateAlert() {
        let alertController = UIAlertController(
            title: I18N.update,
            message: I18N.updateAlert,
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: I18N.update, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: "https://itunes.apple.com/app/\(Bundle.main.appleId)") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: {_ in
                    if KeychainUtil.getAccessToken() != "" {
                        self.skipAuthView()
                        print("토큰 유효")
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: I18N.later, style: .default)
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
    
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let keyWindow = windowScene.windows.first,
                let rootViewController = keyWindow.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
