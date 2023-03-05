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
            $0.text = I18N.emptyTitle
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
            $0.size.equalTo(CGSize(width: 192, height: 219))
        }
        
        emptyLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoImage.snp.bottom).inset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
