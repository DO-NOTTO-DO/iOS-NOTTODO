//
//  ActionCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/19.
//

import UIKit

import SnapKit
import Then

final class ActionCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    var missionCellHeight: ((CGFloat) -> Void)?
    private var fold: FoldState = .folded
    static let identifier = "ActionCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.doAction)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subAction,
                                              colorText: I18N.action)
    private var addMissionTextField = AddMissionTextFieldView(textMaxCount: 20)
    private let exampleLabel = UILabel()
    private let exampleNottodo = UILabel()
    private let exampleActionOne = UILabel()
    private let exampleActionTwo = UILabel()
    private let stackView = UIStackView()
    private let exampleStackView = UIStackView()
    
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
        missionCellHeight?(state == .folded ? 54 : 289)
        updateUI()
        setKeyboardReturnType()
        contentView.layoutIfNeeded()
    }
}

extension ActionCollectionViewCell {
    private func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        stackView.axis = .vertical
        
        exampleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        exampleLabel.do {
            $0.text = I18N.example
            $0.textColor = .gray3
            $0.font = .Pretendard(.regular, size: 14)
        }
        
        exampleNottodo.do {
            $0.text = I18N.exampleNottodo
            $0.textColor = .bg
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        [exampleActionOne, exampleActionTwo].forEach {
            $0.font = .Pretendard(.medium, size: 13)
            $0.textColor = .gray4
        }
        
        exampleActionOne.text = I18N.exampleGoal
        exampleActionTwo.text = I18N.exampleAction
    }
    
    private func setLayout() {
        exampleStackView.addArrangedSubviews(exampleLabel, exampleNottodo)
        stackView.addArrangedSubviews(titleLabel, subTitleLabel, addMissionTextField, exampleStackView, exampleActionOne, exampleActionTwo)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: titleLabel)
            $0.setCustomSpacing(25, after: subTitleLabel)
            $0.setCustomSpacing(12, after: addMissionTextField)
            $0.setCustomSpacing(8, after: exampleStackView)
            $0.setCustomSpacing(6, after: exampleActionOne)
            $0.setCustomSpacing(31, after: exampleActionTwo)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        addMissionTextField.snp.makeConstraints {
            $0.height.equalTo(49)
        }
        
        [exampleActionOne, exampleActionTwo, exampleNottodo].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(37)
            }
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [subTitleLabel, addMissionTextField, exampleLabel, exampleNottodo,
         exampleActionOne, exampleActionTwo].forEach { $0.isHidden = isHidden }
        
        titleLabel.setTitleColor(isHidden)
    }
    
    private func setKeyboardReturnType() {
        addMissionTextField.setReturnType(.default)
    }
}
