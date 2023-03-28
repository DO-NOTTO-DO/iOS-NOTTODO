//
//  DetailAchievementCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/23.
//

import UIKit

class DetailAchievementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "DetailAchievementCollectionViewCell"
    
    // MARK: - UI Components
    
    let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let horizontalStackView = UIStackView()
    private let emptyView = UIView()
    let titleLabel = UILabel()
    private let checkImage = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init!(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DetailAchievementCollectionViewCell {
    private func setUI() {
        contentView.backgroundColor = .clear
        
        tagLabel.do {
            $0.layer.backgroundColor = UIColor.bg?.cgColor
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .gray1
            $0.layer.cornerRadius = 10
        }
        
        horizontalStackView.do {
            $0.addArrangedSubviews(titleLabel, emptyView, checkImage)
            $0.axis = .horizontal
        }
        
        titleLabel.do {
            $0.font = .Pretendard(.semiBold, size: 16)
            $0.textColor = .gray2
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        checkImage.do {
            $0.image = .icChecked
        }
    }
    private func setLayout() {
        addSubviews(tagLabel, horizontalStackView)
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(29)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.size.equalTo(21)
        }
    }
    
    func configure(model: MissionListModel) {
        tagLabel.text = model.title
        titleLabel.text = model.situation
        switch model.completionStatus {
        case .CHECKED: checkImage.isHidden = false
        case .UNCHECKED: checkImage.isHidden = true
        }
    }
}
