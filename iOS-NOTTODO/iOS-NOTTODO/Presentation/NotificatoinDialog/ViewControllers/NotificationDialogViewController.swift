//
//  NotificationDialogViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 11/23/23.
//

import UIKit

import SnapKit
import Then

final class NotificationDialogViewController: UIViewController {
    
    // MARK: - Properties
    
    var buttonHandler: (() -> Void)?
    
    // MARK: - UI Components
    
    private let bellImage = UIImageView()
    private let titleLabel = UILabel()
    private let alertView = UIView()
    private let bottomButton = UIButton()
    private let alertTitleMessageLabel = UILabel()
    private let alertSubTitleMessageLabel = UILabel()
    private let notAllowButton = UIButton()
    private let allowButton = UIButton()
    private let buttonStackView = UIStackView()
    private let circleImage = UIImageView()
    private let backgroundImage =  UIImageView()
    private let verticalView = UIView()
    private let horizontalView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

extension NotificationDialogViewController {
    private func setUI() {
        
        view.backgroundColor = .ntdBlack
        
        bellImage.image = .icBell
        circleImage.image = .icCircle
        backgroundImage.image = .notificationDialog
        
        titleLabel.do {
            $0.text = I18N.notiDialogTitle
            $0.textColor = .white
            $0.font = .Pretendard(.semiBold, size: 22)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        alertTitleMessageLabel.do {
            $0.text = I18N.notiAllowTitle
            $0.textColor = .notiBlack
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        alertSubTitleMessageLabel.do {
            $0.text = I18N.notiAllowSubTitle
            $0.textColor = .gray3
            $0.font = .Pretendard(.medium, size: 13)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        buttonStackView.do {
            $0.makeCornerRound(radius: 17)
            $0.backgroundColor = .none
        }
        
        allowButton.do {
            $0.setTitle(I18N.allow, for: .normal)
            $0.setTitleColor(.notiBlue, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 18)
        }
        
        notAllowButton.do {
            $0.setTitle(I18N.notAllow, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 15)
        }
        
        bottomButton.do {
            $0.backgroundColor = .white
            $0.makeCornerRound(radius: 25)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle(I18N.notiDialogButton, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        alertView.do {
            $0.backgroundColor = .none
            $0.makeCornerRound(radius: 17)
        }
        
        verticalView.backgroundColor = .notiGreen
        horizontalView.backgroundColor = .notiGreen
    }
    
    private func setLayout() {
        view.addSubviews(bellImage, titleLabel, alertView, bottomButton, circleImage)
        alertView.addSubviews(backgroundImage, alertTitleMessageLabel, alertSubTitleMessageLabel, horizontalView, buttonStackView)
        buttonStackView.addArrangedSubviews(notAllowButton, verticalView, allowButton)
        
        bellImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(convertByHeightRatio(63))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(107))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bellImage.snp.bottom).offset(convertByHeightRatio(2))
            $0.directionalHorizontalEdges.equalToSuperview().inset(convertByHeightRatio(57))
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(convertByHeightRatio(44))
            $0.directionalHorizontalEdges.equalToSuperview().inset(convertByHeightRatio(15))
            $0.height.equalTo(convertByHeightRatio(50))
        }
        
        alertView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(convertByHeightRatio(36))
            $0.directionalHorizontalEdges.equalToSuperview().inset(convertByHeightRatio(46))
            $0.bottom.equalTo(bottomButton.snp.top).inset(convertByHeightRatio(-186))
        }
        
        backgroundImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
        
        alertTitleMessageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(26))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(48))
        }
        
        alertSubTitleMessageLabel.snp.makeConstraints {
            $0.top.equalTo(alertTitleMessageLabel.snp.bottom).offset(convertByHeightRatio(7))
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(36))
        }
        
        buttonStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(48))
        }
        
        horizontalView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(1))
            $0.bottom.equalTo(buttonStackView.snp.top)
        }
        
        verticalView.snp.makeConstraints {
            $0.width.equalTo(convertByHeightRatio(1))
        }
        
        circleImage.snp.makeConstraints {
            $0.center.equalTo(allowButton.snp.center)
            $0.size.equalTo(convertByHeightRatio(77))
        }
        
        allowButton.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2)
        }
    }
    
    @objc
    private func buttonTapped() {
        buttonHandler?()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext6)
    }
}
