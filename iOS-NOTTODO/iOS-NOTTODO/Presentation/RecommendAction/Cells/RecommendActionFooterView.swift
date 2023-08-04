//
//  RecommendActionFooterView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

class RecommendActionFooterView: UICollectionReusableView {
    
    // MARK: - Identifier
    
    static let identifier: String = "RecommendActionFooterView"
    
    // MARK: - Properties
    
    var clickedNextButton: (() -> Void)?
    
    // MARK: - UI Components
    
    private let moreButton = UIButton()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension RecommendActionFooterView {
    
    private func setUI() {
        moreButton.do {
            $0.setTitle(I18N.more, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
            $0.setUnderline()
            $0.addTarget(self, action: #selector(moreButtonButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        addSubview(moreButton)
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - @objc function

extension RecommendActionFooterView {
    @objc func moreButtonButtonTapped(_ sender: UIButton) {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.RecommendDetail.clickSelfCreateAction)
        clickedNextButton?()
    }
}
