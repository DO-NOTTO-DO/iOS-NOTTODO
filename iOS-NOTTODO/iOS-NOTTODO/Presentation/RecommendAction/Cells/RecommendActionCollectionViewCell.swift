//
//  RecommendActionCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

class RecommendActionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendActionCollectionViewCell"

    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    
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

extension RecommendActionCollectionViewCell {
    
    private func setUI() {
        contentView.backgroundColor = .gray1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10

        titleLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .white
        }
        
        bodyLabel.do {
            $0.font = .Pretendard(.regular, size: 12)
            $0.textColor = .gray4
            $0.numberOfLines = 0
        }
        
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, bodyLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-40)
        }
    }
    
    func configure(model: RecommendActionModel) {
        titleLabel.text = model.title
        bodyLabel.text = model.body
    }
    
}
