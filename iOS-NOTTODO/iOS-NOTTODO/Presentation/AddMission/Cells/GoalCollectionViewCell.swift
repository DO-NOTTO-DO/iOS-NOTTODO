//
//  GoalCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/20.
//

import UIKit

import SnapKit
import Then

final class GoalCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    var fold: FoldState = .unfolded
    static let identifier = "GoalCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.goal)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subGoal,
                                              colorText: I18N.goal)
    private var addMissionTextField = AddMissionTextFieldView(frame: .zero)
    private let exampleLabel = UILabel()
    private let exampleNottodoLabel = UILabel()
    private let exampleGoalLabel = UILabel()
    private let nottodoTag = PaddingLabel(padding: UIEdgeInsets(top: 3, left: 13, bottom: 3, right: 13))
    private let goalTag = PaddingLabel(padding: UIEdgeInsets(top: 3, left: 13, bottom: 3, right: 13))
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GoalCollectionViewCell {
    func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        exampleLabel.do {
            $0.text = I18N.example
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .gray3
        }
        
        nottodoTag.text = I18N.nottodo
        goalTag.text = I18N.goal
        
        [nottodoTag, goalTag].forEach {
            $0.backgroundColor = .gray2
            $0.layer.cornerRadius = 20 / 2
            $0.clipsToBounds = true
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 12)
        }
        
        exampleNottodoLabel.do {
            $0.text = I18N.exampleNottodo
            $0.textColor = .bg
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        exampleGoalLabel.do {
            $0.text = I18N.exampleGoal
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 13)
        }
    }
    
    func setLayout() {
        addSubviews(titleLabel, subTitleLabel, addMissionTextField,
                    exampleLabel, nottodoTag, exampleNottodoLabel,
                    goalTag, exampleGoalLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(21)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(23)
        }
        
        addMissionTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            $0.directionalHorizontalEdges.equalToSuperview().inset(23)
            $0.height.equalTo(48)
        }
        
        exampleLabel.snp.makeConstraints {
            $0.top.equalTo(addMissionTextField.snp.bottom).offset(13)
            $0.leading.equalToSuperview().inset(25)
        }
        
        nottodoTag.snp.makeConstraints {
            $0.top.equalTo(exampleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(23)
        }
        
        exampleNottodoLabel.snp.makeConstraints {
            $0.centerY.equalTo(nottodoTag.snp.centerY)
            $0.leading.equalTo(nottodoTag.snp.trailing).offset(5)
        }
        
        goalTag.snp.makeConstraints {
            $0.top.equalTo(nottodoTag.snp.bottom).offset(5)
            $0.leading.equalTo(nottodoTag.snp.leading)
        }
        
        exampleGoalLabel.snp.makeConstraints {
            $0.centerY.equalTo(goalTag.snp.centerY)
            $0.leading.equalTo(goalTag.snp.trailing).offset(5)
        }
    }
}
