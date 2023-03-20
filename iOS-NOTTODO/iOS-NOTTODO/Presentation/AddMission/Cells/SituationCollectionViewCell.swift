//
//  SituationCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import Then

final class SituationCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    var fold: FoldState = .unfolded
    static let identifier = "SituationCollectionViewCell"
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.situation)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subSituation,
                                              colorText: I18N.situation)
    private var addMissionTextField = AddMissionTextFieldView(frame: .zero)
    private let recommendKeywordLabel = UILabel()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SituationCollectionViewCell {
    func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        recommendKeywordLabel.do {
            $0.text = I18N.recommendKeyword
            $0.textColor = .white
            $0.font = .Pretendard(.medium, size: 14)
        }
    }
    
    func setLayout() {
        addSubviews(titleLabel, subTitleLabel, addMissionTextField, recommendKeywordLabel)
        
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
        
        recommendKeywordLabel.snp.makeConstraints {
            $0.top.equalTo(addMissionTextField.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(25)
        }
    }
}
