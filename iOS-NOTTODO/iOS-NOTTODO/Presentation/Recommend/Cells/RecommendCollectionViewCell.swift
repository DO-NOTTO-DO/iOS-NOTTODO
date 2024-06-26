//
//  RecommendCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

import SnapKit
import Then

final class RecommendCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendCollectionViewCell"
    private var id: Int = 0

    // MARK: - UI Components
    
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 17, bottom: 4, right: 17))
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let bodyImage = UIImageView()
    
    // MARK: - View Life Cycle
    
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

// MARK: - Methods

extension RecommendCollectionViewCell {
    
    private func setUI() {
        contentView.do {
            $0.backgroundColor = .gray1
            $0.makeCornerRound(radius: 12)
        }
        
        tagLabel.do {
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .white
            $0.backgroundColor = .gray2
            $0.makeCornerRound(radius: 25 / 2)
        }
        
        titleLabel.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
        
        bodyLabel.do {
            $0.font = .Pretendard(.light, size: 14)
            $0.textColor = .gray4
            $0.numberOfLines = 0
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(tagLabel, titleLabel, bodyLabel, bodyImage)
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(tagLabel.snp.centerY)
            $0.leading.equalTo(tagLabel.snp.trailing).offset(8)
        }
        
        bodyImage.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.centerY.equalTo(bodyImage.snp.centerY)
            $0.leading.equalTo(tagLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-101)
        }
    }
    
    func configure(model: RecommendResponseDTO) {
        id = model.id
        tagLabel.text = model.situation
        titleLabel.text = model.title
        bodyLabel.text = model.description
        bodyImage.setImage(with: model.image)
    }
}
