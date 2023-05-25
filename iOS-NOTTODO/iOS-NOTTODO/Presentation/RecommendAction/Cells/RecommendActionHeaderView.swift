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
    private let tagLabel = PaddingLabel()
    private let titleLabel = UILabel()
    private let bodyImage = UIImageView()
    private let arrowIcon = UIImageView()
    private let infoView = UIView()
    private let recommendLabel = UILabel()
    private let recommendSubLabel = UILabel()
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
        
        arrowIcon.image = .downArrow
        infoIcon.image = .icInfo
        
        recommendLabel.do {
            $0.text = I18N.recommendAction
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
        
        recommendSubLabel.do {
            $0.text = I18N.recommendActionSub
            $0.font = .Pretendard(.regular, size: 15)
            $0.textColor = .gray4
        }
    }
    
    private func setLayout() {
        addSubviews(topView, arrowIcon, infoView)
        infoView.addSubviews(recommendLabel, infoIcon, recommendSubLabel)
        topView.addSubviews(tagLabel, titleLabel, bodyImage)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(122)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(138)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.leading.equalToSuperview().offset(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(32)
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
            $0.top.equalToSuperview().offset(47)
            $0.leading.equalToSuperview().offset(28)
        }
        
        infoIcon.snp.makeConstraints {
            $0.centerY.equalTo(recommendLabel.snp.centerY)
            $0.leading.equalTo(recommendLabel.snp.trailing).offset(9)
        }
        
        recommendSubLabel.snp.makeConstraints {
            $0.top.equalTo(recommendLabel.snp.bottom).offset(8)
            $0.leading.equalTo(recommendLabel.snp.leading)
        }
    }
    
    func configure(tag: String?, title: String?, image: UIImage?) {
        // titleLabel.text = model.title
        self.tagLabel.text = tag
        self.bodyImage.image = image
        self.titleLabel.text = title
    }
}
