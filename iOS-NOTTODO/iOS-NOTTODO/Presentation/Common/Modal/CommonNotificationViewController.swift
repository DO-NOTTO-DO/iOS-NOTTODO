//
//  CommonNotificationViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 12/14/23.
//

import UIKit

import SnapKit
import Then
import SafariServices

final class CommonNotificationViewController: UIViewController {
    
    // MARK: - Property
    
    var tapCloseButton: (() -> Void)?
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let highlightView = UIView()
    private let icon = UIImageView()
    private let deprecatedTitle = UILabel()
    private let bottomView = UIView()
    private let blackButton = UIButton()
    private let greenButton = UIButton()
    private let closeButton = UIButton()
    private let deprecatedButton = UIButton()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension CommonNotificationViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
        }
        
        titleLabel.do {
            $0.font = .Pretendard(.semiBold, size: 22)
            $0.textAlignment = .left
            $0.text = "오픈채팅으로\n일일 인증 하고\n갓생살자!"
            $0.numberOfLines = 0
            $0.partHighlightText(targetString: "일일 인증", targetHighlightColor: .green2 ?? .black)
        }
        
        subTitleLabel.do {
            $0.font = .Pretendard(.medium, size: 12)
            $0.textAlignment = .center
            $0.text = "매주 추첨을 통해 스타벅스 기프티콘을 드려요"
        }
        
        highlightView.do {
            $0.backgroundColor = .green2
        }
        
        deprecatedTitle.do {
            $0.font = .Pretendard(.semiBold, size: 15)
            $0.text = I18N.deprecatedTitle
            $0.textColor = .gray3
        }
        
        icon.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .imgOpenChat
        }
        
        bottomView.do {
            $0.backgroundColor = .gray5
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.layer.cornerRadius = 15
        }
        
        blackButton.do {
            $0.backgroundColor = .black
            $0.setTitle(I18N.commonModalTitle, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 13)
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(didFormButtonTap), for: .touchUpInside)
        }
        
        greenButton.do {
            $0.backgroundColor = .green2
            $0.setTitle(I18N.commonModalTitle, for: .normal)
            $0.setTitleColor(.ntdBlack, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 20)
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(didFormButtonTap), for: .touchUpInside)
        }
        
        deprecatedButton.do {
            $0.setImage(.deprecatedCheckBox, for: .normal)
            $0.setImage(.deprecatedCheckBoxFill, for: .selected)
            $0.addTarget(self, action: #selector(didDeprecatedButtonTap), for: .touchUpInside)
        }
        
        closeButton.do {
            $0.setTitle(I18N.close, for: .normal)
            $0.setTitleColor(.ntdBlack, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 15)
            $0.addTarget(self, action: #selector(didCancelButtonTap), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        
        view.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, highlightView, icon, greenButton, bottomView)
        bottomView.addSubviews(deprecatedButton, deprecatedTitle, closeButton)
        
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(278.adjusted)
            $0.height.equalTo(408.adjusted)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17.adjusted)
            $0.leading.equalToSuperview().inset(15.adjusted)
        }
        
        icon.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.adjusted)
            $0.horizontalEdges.equalToSuperview().inset(29.adjusted)
            $0.height.equalTo(173.adjusted)
        }
        
        greenButton.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(9.adjusted)
            $0.horizontalEdges.equalToSuperview().inset(15.adjusted)
            $0.height.equalTo(52.adjusted)
        }
        
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(50.adjusted)
        }
        
        deprecatedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10.adjusted)
            $0.size.equalTo(20.adjusted)
        }
        
        deprecatedTitle.snp.makeConstraints {
            $0.leading.equalTo(deprecatedButton.snp.trailing).offset(6.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(23.adjusted)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - @objc Methods

extension CommonNotificationViewController {
    
    @objc
    func didFormButtonTap() {
        
        guard let url = URL(string: MyInfoURL.commonAlarmModal.url) else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        safariView.delegate = self
        self.present(safariView, animated: true, completion: nil)
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.clickAdModalCta)
    }
    
    @objc
    func didCancelButtonTap() {
        self.tapCloseButton?()
        dismissViewController()
    }
    
    @objc
    func didDeprecatedButtonTap() {
        deprecatedButton.isSelected.toggle()
        KeychainUtil.setBool(deprecatedButton.isSelected,
                             forKey: DefaultKeys.isDeprecatedBtnClicked)
    }
}

extension CommonNotificationViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismissViewController()
    }
}
