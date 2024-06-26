//
//  DetailActionGoalCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/12.
//

import UIKit

import Then
import SnapKit

final class MissionDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MissionDetailCollectionViewCell"
    
    // MARK: - UI Components
    
    private let missionTagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let missionLabel = UILabel()
    private let accumulateView = UIView()
    private let accumulateSubView = UIView()
    private let accumulateLabel = UILabel()
    private let verticalStackView = UIStackView()
    private let action = DetailStackView(tag: I18N.detailAction, isTop: true, empty: .actionEmpty)
    private let goal = DetailStackView(tag: I18N.detailGoal, isTop: false, empty: .goalEmpty)
    
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

// MARK: - Methods

extension MissionDetailCollectionViewCell {
    
    private func setUI() {
        backgroundColor = .clear
        
        missionTagLabel.do {
            $0.backgroundColor = .bg
            $0.makeCornerRound(radius: 12.5)
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .gray1
        }
        
        missionLabel.do {
            $0.font = .Pretendard(.semiBold, size: 20)
            $0.textColor = .gray2
            $0.numberOfLines = 0
        }
        
        accumulateView.do {
            $0.backgroundColor = .green2?.withAlphaComponent(0.3)
            $0.makeCornerRound(radius: 34)
        }
        
        accumulateSubView.do {
            $0.backgroundColor = .green2
            $0.makeCornerRound(radius: 28)
        }
        
        accumulateLabel.do {
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .Pretendard(.semiBold, size: 14)
            $0.numberOfLines = 2
        }
        
        verticalStackView.do {
            $0.addArrangedSubviews(action, goal)
            $0.axis = .vertical
            $0.spacing = 22
        }
        
    }
    
    private func setLayout() {
        contentView.addSubviews(missionTagLabel, accumulateView, missionLabel, verticalStackView)
        accumulateView.addSubviews(accumulateSubView, accumulateLabel)
        
        missionTagLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(29)
        }
        
        accumulateView.snp.makeConstraints {
            $0.top.equalTo(missionTagLabel.snp.top)
            $0.trailing.equalToSuperview().inset(19)
            $0.width.height.equalTo(68)
        }
        
        accumulateSubView.snp.makeConstraints {
            $0.center.centerY.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(missionTagLabel.snp.bottom).offset(10)
            $0.leading.equalTo(missionTagLabel.snp.leading)
            $0.trailing.equalTo(accumulateView.snp.leading).offset(-30)
        }
        
        accumulateLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(missionLabel.snp.bottom).offset(56)
            $0.directionalHorizontalEdges.equalToSuperview().inset(29)
            $0.bottom.equalToSuperview().inset(68)
        }
    }
    
    func configure(model: MissionDetailResponseDTO) {
        missionTagLabel.text = model.situation
        missionLabel.text = model.title
        missionLabel.setLineSpacing(lineSpacing: 6.0)
        accumulateLabel.text = "\(model.count)회\n달성"
        
        let nonEmptyActions = model.actions.filter { !$0.name.isEmpty }
        
        if nonEmptyActions.isEmpty {
            action.titleLabel.isHidden = true
            action.emptyIcon.isHidden = false
        } else {
            let actionNames = nonEmptyActions.map { $0.name }
            let joinedActionNames = actionNames.joined(separator: "\n")
            action.titleLabel.text = joinedActionNames
            action.titleLabel.setLineSpacing(lineSpacing: 7.0)
            action.verticalStackView.removeArrangedSubview(action.emptyIcon)
            action.emptyIcon.removeFromSuperview()
        }
        
        if model.goal.isEmpty {
            goal.titleLabel.isHidden = true
            goal.emptyIcon.isHidden = false
            
        } else {
            goal.verticalStackView.removeArrangedSubview(action.emptyIcon)
            goal.emptyIcon.removeFromSuperview()
            goal.titleLabel.text = model.goal
        }
    }
}
