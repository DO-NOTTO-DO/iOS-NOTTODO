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
    
    private let verticalStackView = UIStackView()
    private let action = DetailStackView(tag: "실천 행동")
    private let goal = DetailStackView(tag: "목표")
    
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
        
        verticalStackView.do {
            $0.addArrangedSubviews(action, goal)
            $0.axis = .vertical
            $0.spacing = 22
        }
    }
    
    private func setLayout() {
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(29)
            $0.bottom.equalToSuperview().inset(35)
        }
    }
    
    func configure(model: MissionDetailModel) {
        action.titleLabel.text = "model.action?.joined(separator: ',')\n"
//        goal.titleLabel.text = model.goal?.joined(separator: ",")
        goal.titleLabel.text = "model.goal?.joined(separator: ',')\n"

    }
}
