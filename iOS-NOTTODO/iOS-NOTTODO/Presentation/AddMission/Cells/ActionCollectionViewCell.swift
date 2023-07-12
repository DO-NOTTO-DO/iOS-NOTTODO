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
    
    static let identifier = "ActionCollectionViewCell"
    var missionCellHeight: ((CGFloat) -> Void)?
    var missionTextData: (([String]) -> Void)?
    private var fold: FoldState = .folded
    
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
    private let foldStackView = UIStackView()
    private let paddingView = UIView()
    
    private let checkImage = UIImageView()
    private let enterMessage = UILabel()
    private let optionLabel = UILabel()
    
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
    
    func setCellData(_ text: [String]) {
        if text.first!.isEmpty {
            enterMessage.text = I18N.enterMessage
            enterMessage.textColor = .gray3
            enterMessage.font = .Pretendard(.regular, size: 15)
        } else {
            enterMessage.text = text.first!
            enterMessage.textColor = .white
            enterMessage.font = .Pretendard(.medium, size: 15)
        }
        addMissionTextField.setText(text.first!)
    }
}

extension ActionCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        checkImage.image = .icChecked
        stackView.axis = .vertical
        foldStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 9
        }
        
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
        
        enterMessage.do {
            $0.text = I18N.enterMessage
            $0.textColor = .gray3
            $0.font = .Pretendard(.regular, size: 15)
        }
        
        optionLabel.do {
            $0.text = I18N.option
            $0.textColor = .green1
            $0.font = .Pretendard(.regular, size: 15)
        }
    }
    
    private func setLayout() {
        foldStackView.addArrangedSubviews(titleLabel, enterMessage, paddingView, optionLabel, checkImage)
        exampleStackView.addArrangedSubviews(exampleLabel, exampleNottodo)
        stackView.addArrangedSubviews(foldStackView, subTitleLabel, addMissionTextField, exampleStackView, exampleActionOne, exampleActionTwo)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: foldStackView)
            $0.setCustomSpacing(25, after: subTitleLabel)
            $0.setCustomSpacing(12, after: addMissionTextField)
            $0.setCustomSpacing(8, after: exampleStackView)
            $0.setCustomSpacing(6, after: exampleActionOne)
            $0.setCustomSpacing(31, after: exampleActionTwo)
        }
        
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18).priority(.high)
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
        enterMessage.isHidden = !isHidden
        checkImage.isHidden = !isHidden ? true : addMissionTextField.getTextFieldText().isEmpty
        optionLabel.isHidden = !isHidden ? true : !addMissionTextField.getTextFieldText().isEmpty
        titleLabel.setTitleColor(isHidden)
        
        backgroundColor = isHidden ? .clear : .gray1
        layer.borderColor = isHidden ? UIColor.gray2?.cgColor : UIColor.gray3?.cgColor
        
        addMissionTextField.textFieldData = { string in
            self.missionTextData?(([string]))
        }
    }
    
    private func setKeyboardReturnType() {
        addMissionTextField.setReturnType(.default)
    }
}
