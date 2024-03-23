//
//  DetailAchievementCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/23.
//

import UIKit

import SnapKit
import Then

final class DetailAchievementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "DetailAchievementCollectionViewCell"
    
    // MARK: - UI Components
    
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let titleLabel = UILabel()
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
            $0.makeCornerRound(radius: 25/2)
        }
        
        titleLabel.do {
            $0.font = .Pretendard(.semiBold, size: 16)
            $0.textColor = .gray2
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
        
        checkImage.do {
            $0.image = .icChecked
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(tagLabel, titleLabel, checkImage)
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().inset(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(50)
        }
        
        checkImage.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(21)
            $0.trailing.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configure(model: AchieveDetailData) {
        tagLabel.text = model.situation
        titleLabel.text = model.title
        titleLabel.lineBreakMode = .byTruncatingTail
        checkImage.isHidden = model.status == .UNCHECKED
    }
}
