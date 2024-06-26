//
//  SubOnboardingCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import SnapKit
import Then

final class SubOnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SubOnboardingCollectionViewCell"
    
    // MARK: - UI Components
    private let iconImage = UIImageView()
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 2, left: 7, bottom: 2, right: 7))
    private let titleLabel = UILabel()
    
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

extension SubOnboardingCollectionViewCell {
    private func setUI() {
        contentView.backgroundColor = .gray1
        contentView.makeCornerRound(radius: 35)
        
        tagLabel.do {
            $0.makeCornerRound(radius: 8)
            $0.backgroundColor = UIColor.gray8
            $0.font = .Pretendard(.regular, size: 10)
            $0.textColor = .gray6
        }
        titleLabel.do {
            $0.font = .Pretendard(.regular, size: 13)
            $0.textColor = .white
        }
    }
    
    private func setLayout() {
        addSubviews(iconImage, tagLabel, titleLabel)
        
        iconImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(21)
            $0.size.equalTo(36)
        }
        tagLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImage.snp.trailing).offset(13)
            $0.top.equalToSuperview().offset(15)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(tagLabel.snp.leading)
            $0.top.equalTo(tagLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(model: FourthOnboardingModel) {
        iconImage.image = model.icon
        tagLabel.text = model.tag
        titleLabel.text = model.title
    }
}
