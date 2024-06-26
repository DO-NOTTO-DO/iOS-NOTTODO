//
//  StatisticsView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/06.
//

import UIKit

import Then
import SnapKit

final class StatisticsView: UIView {
    
    // MARK: - UI Components
    
    private let totalImage = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - View Life Cycle
    
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

extension StatisticsView {
    
    private func setUI() {
        
        totalImage.do {
            $0.image = .icFeedback
        }
        
        titleLabel.do {
            $0.text = I18N.total
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .gray5
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    private func setLayout() {
        addSubviews(totalImage, titleLabel)
        
        totalImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18.adjusted)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(127.adjusted)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(totalImage.snp.bottom).offset(6.adjusted)
            $0.centerX.equalToSuperview()
        }
    }
}
