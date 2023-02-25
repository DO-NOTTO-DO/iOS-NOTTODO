//
//  RecommendActionHeaderView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

class RecommendActionHeaderView: UICollectionReusableView {
    
    // MARK: - Identifier
    
    static let identifier: String = "RecommendActionHeaderView"
    
    // MARK: - UI Components
    
    private let topView = UIView()
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 17, bottom: 4, right: 17))
    private let titleLabel = UILabel()
    private let bodyImage = UIImageView()
    private let arrowIcon = UIImageView()
    private let recommendLabel = UILabel()
    private let infoIcon = UIImageView()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension RecommendActionHeaderView {
    
    private func setUI() {
        topView.backgroundColor = .gray1
        
        tagLabel.do {
            $0.text = "자기 전" // 추후 데이터 연결 필요
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .white
            $0.backgroundColor = .gray2
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 25 / 2
        }
        
        titleLabel.do {
            $0.text = "자기 2시간 전 야식 먹지 않기" // 추후 데이터 연결 필요
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
        
        bodyImage.image = .food // 추후 데이터 연결 필요
        arrowIcon.image = .icArrow
        infoIcon.image = .icInfo
    }
    
    private func setLayout() {
        addSubviews(topView, arrowIcon, recommendLabel, infoIcon)
        topView.addSubviews(tagLabel, titleLabel, bodyImage)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(122)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.leading.equalToSuperview().offset(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(6)
            $0.leading.equalTo(tagLabel.snp.trailing).offset(32)
        }
        
        bodyImage.snp.makeConstraints {
            $0.width.height.equalTo(70)
            $0.trailing.equalToSuperview().offset(-27)
            $0.centerY.equalToSuperview()
        }
        
        arrowIcon.snp.makeConstraints {
            $0.centerY.equalTo(topView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        recommendLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(46)
            $0.leading.equalToSuperview().offset(28)
        }
        
        infoIcon.snp.makeConstraints {
            $0.centerY.equalTo(recommendLabel.snp.centerY)
            $0.leading.equalTo(recommendLabel.snp.trailing).offset(9)
        }
    }
}

