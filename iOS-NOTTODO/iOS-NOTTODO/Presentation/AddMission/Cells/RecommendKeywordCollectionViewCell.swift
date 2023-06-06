//
//  RecommendKeywordCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/20.
//

import UIKit

import SnapKit
import Then

final class RecommendKeywordCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendKeywordCollectionViewCell"
    
    // MARK: - UI Components
    
    private let recommendLabel = PaddingLabel()
    
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
    
    func getText() -> String {
        if let text = recommendLabel.text {
            return text
        }
        return ""
    }
}

private extension RecommendKeywordCollectionViewCell {
    func setUI() {
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.clipsToBounds = true
        recommendLabel.do {
            $0.backgroundColor = .gray2
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 14)
        }
    }
    
    func setLayout() {
        contentView.addSubview(recommendLabel)
        
        recommendLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension RecommendKeywordCollectionViewCell {
    func configure(_ item: RecommendSituationResponseDTO) {
        recommendLabel.text = item.name
    }
}
