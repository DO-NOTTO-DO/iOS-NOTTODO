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
    private let bottomButton = UIButton()
    
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
        
        titleLabel.do {
            $0.text = I18N.notiDialogTitle
            $0.textColor = .white
            $0.font = .Pretendard(.semiBold, size: 22)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        bottomButton.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle(I18N.notiDialogButton, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
    }
    
    private func setLayout() {
        view.addSubviews(bellImage, titleLabel, bottomButton)
        
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
    }
    
    @objc
    private func buttonTapped() {
        buttonHandler?()
    }
}
