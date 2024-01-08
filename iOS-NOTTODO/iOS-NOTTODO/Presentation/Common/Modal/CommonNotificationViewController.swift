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
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let icon = UIImageView()
    private let deprecatedTitle = UILabel()
    private let bottomView = UIView()
    private lazy var formButton = UIButton()
    private lazy var closeButton = UIButton()
    private lazy var deprecatedButton = UIButton()

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
            $0.font = .Pretendard(.bold, size: 18)
            $0.textAlignment = .center
            $0.text = "1분 서비스 피드백하고 \n기프티콘 받아가세요!"
            $0.numberOfLines = 2
        }
        
        subTitleLabel.do {
            $0.font = .Pretendard(.medium, size: 12)
            $0.textAlignment = .center
            $0.text = "매주 추첨을 통해 스타벅스 기프티콘을 드려요"
        }
        
        deprecatedTitle.do {
            $0.font = .Pretendard(.medium, size: 13)
            $0.text = I18N.deprecatedTitle
            $0.textColor = .gray3
        }
        
        icon.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icStarbucks
        }
        
        bottomView.do {
            $0.backgroundColor = .gray5
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.layer.cornerRadius = 15
        }
        
        formButton.do {
            $0.backgroundColor = .black
            $0.setTitle(I18N.formButton, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 13)
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(didFormButtonTap), for: .touchUpInside)
        }
        
        deprecatedButton.do {
            $0.setImage(.deprecatedCheckBox, for: .normal)
            $0.setImage(.deprecatedCheckBoxFill, for: .selected)
            $0.addTarget(self, action: #selector(didDeprecatedButtonTap), for: .touchUpInside)
        }
        
        closeButton.do {
            $0.setTitle(I18N.close, for: .normal)
            $0.setTitleColor(.gray3, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 13)
            $0.addTarget(self, action: #selector(didCancelButtonTap), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        
        view.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subTitleLabel, icon, formButton, bottomView)
        bottomView.addSubviews(deprecatedButton, deprecatedTitle, closeButton)
        
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalTo(408)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(197)
        }
        
        formButton.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(40)
        }
        
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        deprecatedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(20)
        }
        
        deprecatedTitle.snp.makeConstraints {
            $0.leading.equalTo(deprecatedButton.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - @objc Methods

extension CommonNotificationViewController {
    
    @objc
    func didFormButtonTap() {

        guard let url = URL(string: MyInfoURL.googleForm.url) else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        safariView.delegate = self
        self.present(safariView, animated: true, completion: nil)
    }
    
    @objc
    func didCancelButtonTap() {
        dismissViewController()
    }
    
    @objc
    func didDeprecatedButtonTap() {
        deprecatedButton.isSelected.toggle()
        KeychainUtil.setBool(deprecatedButton.isSelected,
                             forKey: DefaultKeys.isSelected)
    }
}

extension CommonNotificationViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismissViewController()
    }
}
