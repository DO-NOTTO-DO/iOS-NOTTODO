//
//  MyInfoAccountCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import UIKit

import SnapKit
import Then

final class MyInfoAccountCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MyInfoAccountCollectionViewCell"
    
    private var isNotificationAllowed: Bool {
        return KeychainUtil.getBool(DefaultKeys.isNotificationAccepted)
    }
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let notificationSwitch = UISwitch()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension MyInfoAccountCollectionViewCell {
    
    private func setUI() {
        backgroundColor = .gray1
        
        titleLabel.do {
            $0.font = .Pretendard(.medium, size: 14)
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
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, contentLabel, notificationSwitch)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
    }
    
    func configure(data: AccountRowData) {
        titleLabel.textColor = data.titleColor
        titleLabel.text = data.title
        
        if data.isSwitch {
            contentLabel.removeFromSuperview()
        } else {
            notificationSwitch.removeFromSuperview()
            contentLabel.text = data.content
        }
    }
}

extension MyInfoAccountCollectionViewCell {
    
    @objc
    func switchTapped(_ sender: Any) {
        
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
                    
                    //  self?.delegate?.switchTapped(isNotificationAllowed)
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
