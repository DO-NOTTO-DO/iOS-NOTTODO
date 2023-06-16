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
    
    var missionCellHeight: ((CGFloat) -> Void)?
    private var fold: FoldState = .folded
    static let identifier = "GoalCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.goal)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subGoal,
                                              colorText: I18N.goal)
    private var addMissionTextField = AddMissionTextFieldView(textMaxCount: 20)
    private let exampleLabel = UILabel()
    private let exampleNottodoLabel = UILabel()
    private let exampleGoalLabel = UILabel()
    private let stackView = UIStackView()
    private let nottodoStackView = UIStackView()
    private let goalStackView = UIStackView()
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
    
    func setFoldState(_ state: FoldState) {
        fold = state
        missionCellHeight?(state == .folded ? 54 : 307)
        updateUI()
        contentView.layoutIfNeeded()
    }
}

private extension GoalCollectionViewCell {
    func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        stackView.axis = .vertical
        [nottodoStackView, goalStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 5
        }
        
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
        stackView.addArrangedSubviews(titleLabel, subTitleLabel, addMissionTextField, exampleLabel, nottodoStackView, goalStackView)
        nottodoStackView.addArrangedSubviews(nottodoTag, exampleNottodoLabel)
        goalStackView.addArrangedSubviews(goalTag, exampleGoalLabel)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        goalStackView.snp.makeConstraints {
            $0.width.equalTo(186)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: titleLabel)
            $0.setCustomSpacing(25, after: subTitleLabel)
            $0.setCustomSpacing(13, after: addMissionTextField)
            $0.setCustomSpacing(8, after: exampleLabel)
            $0.setCustomSpacing(5, after: nottodoStackView)
        }
        
        nottodoTag.snp.makeConstraints {
            $0.width.equalTo(58)
        }
        
        goalTag.snp.makeConstraints {
            $0.width.equalTo(47)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        addMissionTextField.snp.makeConstraints {
            $0.height.equalTo(49)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [subTitleLabel, addMissionTextField, exampleLabel, nottodoStackView, goalStackView].forEach { $0.isHidden = isHidden }
        
        titleLabel.setTitleColor(isHidden)
    }
}
