//
//  FirebaseUtil.swift
//  iOS-NOTTODO
//
//  Created by 김혜수 on 1/23/24.
//

import Foundation

import FirebaseRemoteConfig

final class FirebaseUtil {
    
    static let shared = FirebaseUtil()
    
    private let config = RemoteConfig.remoteConfig()
    
    enum RemoteConfigType {
        case minimumVersion
    }
    
    init() {
        self.setRemoteConfigSetting()
    }
    
    func fetchRemoteConfig(type: RemoteConfigType) async -> String? {
        return await withCheckedContinuation { continuation in
            config.fetch { [weak self] status, _ in
                if status == .success {
                    self?.config.activate()
                    guard let version = self?.config["minimum_version"].stringValue, !version.isEmpty else {
                        continuation.resume(returning: nil)
                        return
                    }
                    continuation.resume(returning: version)
                }
            }
        }
    }
    
    private func setRemoteConfigSetting() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        setting.fetchTimeout = 10
        config.configSettings = setting
    }
}
