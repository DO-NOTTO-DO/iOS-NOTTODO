//
//  HomeEmptyCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/28.
//

import UIKit

class HomeEmptyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let identifier = "HomeEmptyCollectionViewCell"

    // MARK: - UI Components
    
    private let logoImage = UIImageView()
    private let emptyLabel = UILabel()

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

extension HomeEmptyCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        
        logoImage.do {
            $0.image = .emptyLogo
        }
        
        emptyLabel.do {
            $0.text = "새로운 낫투두를 추가하고\n오늘 하루를 더 잘 살아보세요!"
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .gray4
            $0.font = .Pretendard(.semiBold, size: 16)
        }
    }
    
    private func setLayout() {
        addSubviews(logoImage, emptyLabel)
        
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().inset(113)
            $0.size.equalTo(CGSize(width: 106, height: 70))
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(33)
            $0.centerX.equalToSuperview()
        }
    }
}

