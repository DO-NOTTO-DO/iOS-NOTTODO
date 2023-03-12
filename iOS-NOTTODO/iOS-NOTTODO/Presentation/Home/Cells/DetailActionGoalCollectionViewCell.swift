//
//  DetailActionGoalCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/12.
//

import UIKit

import Then
import SnapKit

class DetailActionGoalCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let identifier = "DetailActionGoalCollectionViewCell"

    // MARK: - UI Components
    
    private let actionTagLabel = UILabel()
    private let actionLabel = UILabel()
    private let goalTagLabel = UILabel()
    private let goalLabel = UILabel()
    
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

extension DetailActionGoalCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        
        actionTagLabel.do {
            $0.text = "실천 행동"
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 15)
        }
    
    }
    
    private func setLayout() {
       
    }
    
    func configure(model: MissionDetailModel) {
        actionLabel.text = model.action?.joined(separator: ",")
        goalLabel.text = model.goal?.joined(separator: ",")
    }
}
