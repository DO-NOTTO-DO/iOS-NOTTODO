//
//  RecommendCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

import SnapKit
import Then

class RecommendCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendCollectionViewCell"

    // MARK: - UI Components
    
    let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 17, bottom: 4, right: 17))
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let bodyImage = UIImageView()
    
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
        contentView.backgroundColor = .gray1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        
        tagLabel.do {
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .white
            $0.backgroundColor = .gray2
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 25 / 2
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
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(12)
            $0.leading.equalTo(tagLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-101)
        }
        
        bodyImage.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(model: RecommendModel) {
        tagLabel.text = model.tag
        titleLabel.text = model.title
        bodyLabel.text = model.body
        bodyImage.image = UIImage(named: model.image)
    }
    
}
