//
//  OnboardingFooterView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/23.
//

import UIKit

import Then
import SnapKit

class OnboardingFooterView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "OnboardingFooterView"
    
    // MARK: - UI Components
    
    private let iconImage = UIImageView()
    private let actionLabel = UILabel()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method

extension OnboardingFooterView {
    private func setUI() {
        iconImage.do {
            $0.image = .downArrow
        }
        actionLabel.do {
            $0.text = "실천 방법"
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .white
        }
    }
    
    private func setLayout() {
        addSubviews(iconImage, actionLabel)

        iconImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        actionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
}

