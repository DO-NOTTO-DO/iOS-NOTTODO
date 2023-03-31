//
//  StatisticsView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/06.
//

import UIKit

import Then
import SnapKit

class StatisticsView: UIView {
    
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
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray4?.cgColor
        
        totalImage.do {
            $0.image = .imgTotal
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
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
        }
    }
}
