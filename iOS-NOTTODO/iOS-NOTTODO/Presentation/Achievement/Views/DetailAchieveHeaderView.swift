//
//  DetailAchieveHeaderView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 11/19/23.
//

import UIKit

import SnapKit
import Then

final class DetailAchieveHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "DetailAchieveHeaderView"
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel()
    
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

extension DetailAchieveHeaderView {
    
    private func setUI() {
        
        dateLabel.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .gray2
            $0.textAlignment = .center
        }
    }
    
    private func setLayout() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(text: String) {
        dateLabel.text = text
    }
}
