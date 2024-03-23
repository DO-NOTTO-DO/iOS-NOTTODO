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
    
    static let identifier = "GoalCollectionViewCell"
    var missionCellHeight: ((CGFloat) -> Void)?
    var missionTextData: (([String]) -> Void)?
    private var fold: FoldState = .folded
    
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
    private let nottodoPaddingView = UIView()
    private let goalPaddingView = UIView()
    
    private let nottodoTag = PaddingLabel(padding: UIEdgeInsets(top: 3, left: 13, bottom: 3, right: 13))
    private let goalTag = PaddingLabel(padding: UIEdgeInsets(top: 3, left: 13, bottom: 3, right: 13))
    
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
        missionCellHeight?(state == .folded ? 54 : 307)
        updateUI()
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

private extension GoalCollectionViewCell {
    func setUI() {
        backgroundColor = .clear
        makeCornerRound(radius: 12)
        makeBorder(width: 1, color: .gray3!)
        checkImage.image = .icChecked
        stackView.axis = .vertical
        [nottodoStackView, goalStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        foldStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 9
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
            $0.makeCornerRound(radius: 20 / 2)
            $0.clipsToBounds = true
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 12)
        }
        
        exampleNottodoLabel.do {
            $0.text = I18N.exampleGoalNottodo
            $0.textColor = .bg
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        exampleGoalLabel.do {
            $0.text = I18N.exampleGoal
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 13)
        }
        
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
    
    func setLayout() {
        stackView.addArrangedSubviews(foldStackView, subTitleLabel, addMissionTextField, exampleLabel, nottodoStackView, goalStackView)
        nottodoStackView.addArrangedSubviews(nottodoTag, exampleNottodoLabel, nottodoPaddingView)
        goalStackView.addArrangedSubviews(goalTag, exampleGoalLabel, goalPaddingView)
        foldStackView.addArrangedSubviews(titleLabel, enterMessage, paddingView, optionLabel, checkImage)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        
        goalStackView.snp.makeConstraints {
            $0.width.equalTo(186)
        }
        
        foldStackView.do {
            $0.setCustomSpacing(39, after: titleLabel)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: foldStackView)
            $0.setCustomSpacing(25, after: subTitleLabel)
            $0.setCustomSpacing(13, after: addMissionTextField)
            $0.setCustomSpacing(8, after: exampleLabel)
            $0.setCustomSpacing(5, after: nottodoStackView)
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
    }
    
    private func updateUI() {
        let isHidden: Bool = (fold == .folded)
        
        [subTitleLabel, addMissionTextField, exampleLabel, nottodoStackView, goalStackView].forEach { $0.isHidden = isHidden }
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
}
