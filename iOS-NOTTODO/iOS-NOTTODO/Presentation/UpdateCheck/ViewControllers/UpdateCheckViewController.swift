//
//  UpdateCheckViewController.swift
//  iOS-NOTTODO
//
//  Created by 김혜수 on 1/26/24.
//

import UIKit

final class UpdateCheckViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    private weak var coordinator: UpdateCoordinator?
    
    // MARK: - init
    
    init(coordinator: UpdateCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
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
                    coordinator?.showForceUpdateAlertController(newVersion: newVersion)
                case .optional:
                    coordinator?.showUpdateAlertController()
                case .none:
                    coordinator?.changeMainViewController()
                }
            } catch {
                coordinator?.changeMainViewController()
            }
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
}
