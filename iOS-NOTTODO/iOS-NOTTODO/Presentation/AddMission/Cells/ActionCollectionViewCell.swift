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
        updateLayout()
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
        contentView.addSubviews(titleLabel, subTitleLabel, addMissionTextField, exampleLabel,
                    exampleNottodo, exampleActionOne, exampleActionTwo)
        updateLayout()
        updateUI()
    }
    
    private func updateLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(21)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(23)
        }
        
//        let textFieldHeight: CGFloat = fold == .folded ? 0 : 48
        addMissionTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            $0.directionalHorizontalEdges.equalToSuperview().inset(23)
            $0.height.equalTo(48)
        }
        
        exampleLabel.snp.makeConstraints {
            $0.top.equalTo(addMissionTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(23)
        }
        
        exampleNottodo.snp.makeConstraints {
            $0.centerY.equalTo(exampleLabel)
            $0.leading.equalTo(exampleLabel.snp.trailing).offset(8)
        }
        
        exampleActionOne.snp.makeConstraints {
            $0.top.equalTo(exampleNottodo.snp.bottom).offset(8)
            $0.leading.equalTo(exampleNottodo.snp.leading)
        }
        
        exampleActionTwo.snp.makeConstraints {
            $0.top.equalTo(exampleActionOne.snp.bottom).offset(6)
            $0.leading.equalTo(exampleNottodo.snp.leading)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [titleLabel, subTitleLabel, addMissionTextField, exampleLabel, exampleNottodo,
         exampleActionOne, exampleActionTwo].forEach { $0.isHidden = isHidden }
    }
    
    private func setKeyboardReturnType() {
        addMissionTextField.setReturnType(.default)
    }
}
