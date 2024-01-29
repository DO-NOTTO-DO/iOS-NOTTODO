//
//  UpdateCheckViewController.swift
//  iOS-NOTTODO
//
//  Created by 김혜수 on 1/26/24.
//

import UIKit

final class UpdateCheckViewController: UIViewController {
    
    enum UpdateType {
        case optional
        case force(newVersion: String)
        case none
    }
    
    enum UpdateCheckError: Error {
        case versionFetchError
    }
    
    enum Constant {
        static let appstoreURL: String = "itms-apps://itunes.apple.com/app/\(Bundle.main.appleId)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.checkUpdate()
    }
}

extension UpdateCheckViewController {
    private func setUI() {
        self.view.backgroundColor = .ntdBlack
    }
    
    private func checkUpdate() {
        Task {
            do {
                let updateType = try await checkUpdateType()
                switch updateType {
                case .force(let newVersion):
                    self.showForceUpdateAlert(newVersion: newVersion)
                case .optional:
                    self.showUpdateAlert()
                case .none:
                    self.changeMainViewController()
                }
            } catch {
                self.changeMainViewController()
            }
        }
    }
    
    private func changeMainViewController() {
        if KeychainUtil.getAccessToken().isEmpty {
            SceneDelegate.shared?.changeRootViewControllerTo(ValueOnboardingViewController())
        } else {
            SceneDelegate.shared?.changeRootViewControllerTo(TabBarController())
        }
    }
    
    private func checkUpdateType() async throws -> UpdateType {
        // 앱스토어 버전
        guard let appstoreVersion = try await getAppstoreVersion() else {
            throw UpdateCheckError.versionFetchError
        }
        
        // 현재 설치된 앱의 버전
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            throw UpdateCheckError.versionFetchError
        }
        
        // 최소 지원버전
        guard let minimumVersion = await FirebaseUtil.shared.fetchRemoteConfig(type: .minimumVersion) else {
            throw UpdateCheckError.versionFetchError
        }
        
        if shouldUpdate(userVersion: appVersion, appstoreVersion: minimumVersion) {
            return .force(newVersion: appstoreVersion)
        }
        
        if shouldUpdate(userVersion: appVersion, appstoreVersion: appstoreVersion) {
            return .optional
        }
        
        return .none
    }
    
    /// 버전 비교하는 메서드
    private func shouldUpdate(userVersion: String, appstoreVersion: String) -> Bool {
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
    private func getAppstoreVersion() async throws -> String? {
        let appleID = Bundle.main.appleId
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)") else { return nil }
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        guard let results = json?["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    /// 선택 업데이트 경고창
    private func showUpdateAlert() {
        let alertController = UIAlertController(
            title: I18N.update,
            message: I18N.updateAlert,
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: I18N.update, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: Constant.appstoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { [weak self] _ in
                    self?.changeMainViewController()
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: I18N.later, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: Constant.appstoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: { [weak self] _ in
                    self?.changeMainViewController()
                })
            }
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    /// 강제 업데이트 경고창
    private func showForceUpdateAlert(newVersion: String) {
        let alertController = UIAlertController(
            title: I18N.update,
            message: I18N.forceUpdateAlert(newVersion: newVersion),
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: I18N.update, style: .default) { _ in
            // App Store로 이동
            if let appStoreURL = URL(string: Constant.appstoreURL) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(updateAction)
        self.present(alertController, animated: true)
    }
}
