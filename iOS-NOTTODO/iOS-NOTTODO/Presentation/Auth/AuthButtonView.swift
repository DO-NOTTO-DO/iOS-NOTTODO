//
//  authButtonView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/17.
//

import UIKit

import SnapKit
import Then

final class AuthButtonView: UIView {
    
    // MARK: - UI Components
    
    private var buttonView = UIView()
    private var buttonIcon = UIImageView()
    private var buttonLabel = UILabel()
    
    // MARK: - View Life Cycles
    
    init(frame: CGRect, title: String?, icon: UIImage?, color: UIColor?) {
        super.init(frame: frame)
        setUI(title: title, icon: icon, color: color)
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension AuthButtonView {
    private func setUI(title: String?, icon: UIImage?, color: UIColor?) {
        
        buttonView.do {
            $0.backgroundColor = color
            $0.makeCornerRound(radius: 5)
        }
        
        buttonIcon.image = icon
        
        buttonLabel.do {
            $0.text = title
            $0.textColor = .systemBlack
            $0.font = .Pretendard(.medium, size: 16)
        }
    }
    
    private func setLayout() {
        addSubviews(buttonView)
        buttonView.addSubviews(buttonIcon, buttonLabel)
        
        self.snp.makeConstraints {
            $0.height.equalTo(53)
        }
        
        buttonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalToSuperview()
        }
        
        buttonIcon.snp.makeConstraints {
            $0.centerX.equalTo(buttonView.snp.leading).offset(27)
            $0.centerY.equalToSuperview()
        }
        
        buttonLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
