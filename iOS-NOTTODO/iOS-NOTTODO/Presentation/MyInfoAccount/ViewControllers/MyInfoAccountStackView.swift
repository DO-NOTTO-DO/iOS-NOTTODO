//
//  MyInfoAccountStackView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/18.
//

import UIKit

import SnapKit
import Then
import UserNotifications

final class MyInfoAccountStackView: UIView {
    
    // MARK: - UI Components
    
    private let stackView = UIView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let notificationSwitch = UISwitch()
    private let lineView = UIView()
    var switchClosure: ((_ isTapped: Bool) -> Void)?
    private var isNotificationAllowed: Bool {
        return KeychainUtil.getBool(DefaultKeys.isNotificationAccepted)
    }
    
    // MARK: - View Life Cycle
    
    init(title: String, isHidden: Bool) {
        super.init(frame: .zero)
        setUI(title: title, isHidden: isHidden)
        setLayout(isHidden: isHidden)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
}

// MARK: - Methods

extension MyInfoAccountStackView {
    private func setUI(title: String, isHidden: Bool) {
        makeCornerRound(radius: 10)
        
        titleLabel.do {
            $0.text = title
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .white
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        contentLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .gray6
            $0.numberOfLines = 0
            $0.textAlignment = .right
        }
        
        notificationSwitch.do {
            $0.isOn = isNotificationAllowed
            $0.onTintColor = .green2
            $0.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        }
        
        lineView.do {
            $0.backgroundColor = .gray2
            $0.isHidden = isHidden ? true : false
        }
    }
    
    private func setLayout(isHidden: Bool) {
        addSubviews(lineView, stackView)
        stackView.addSubviews(titleLabel, isHidden ? notificationSwitch : contentLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        if !isHidden {
            contentLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
        } else {
            notificationSwitch.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.height.equalTo(30)
                $0.width.equalTo(50)
            }
        }
        
        lineView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    @objc func switchTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            do {
                try self.toggleNotificationPermission()
            } catch {
                print("Error toggling notification permission: \(error)")
            }
        }
    }
    
    private func toggleNotificationPermission() throws {
        do {
            try self.openAppSettings()
        } catch {
            throw error
        }
    }
    
    private func openAppSettings() throws {
        let settingsUrl: URL
        if #available(iOS 16.0, *) {
            settingsUrl = URL(string: UIApplication.openNotificationSettingsURLString) ?? URL(string: "")!
        } else {
            settingsUrl = URL(string: UIApplication.openSettingsURLString) ?? URL(string: "")!
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { success in
                print("iOS 설정 앱 열기: \(success)")
            })
        }
    }
    
    @objc
    private func appWillEnterForeground() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                KeychainUtil.setBool(settings.authorizationStatus == .authorized, forKey: DefaultKeys.isNotificationAccepted)
                if let isNotificationAllowed = self?.isNotificationAllowed {
                    self?.switchClosure?(isNotificationAllowed)
                }
                
                if KeychainUtil.getBool(DefaultKeys.isNotificationAccepted) {
                    AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completePushOn)
                } else {
                    AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completePushOff)
                }
            }
        }
    }
}
