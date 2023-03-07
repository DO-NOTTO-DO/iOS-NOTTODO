//
//  MyInfoCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

class MyInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let identifier = "MyInfoCollectionViewCell"

    // MARK: - UI Components
    
    private let logoImage = UIImageView()
    private let verticalStackView = UIStackView()
    private let userLabel = UILabel()
    private let emailLabel = UILabel()

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

extension MyInfoCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        
        logoImage.do {
            $0.image = .emptyLogo
        }
        
        userLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.textColor = .white
            $0.font = .Pretendard(.regular, size: 15)
        }
        emailLabel.do {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.textColor = .gray4
            $0.font = .Pretendard(.regular, size: 12)
        }
        verticalStackView.do {
            $0.addArrangedSubviews(userLabel, emailLabel)
            $0.axis = .vertical
            $0.spacing = 4
        }
    }
    
    private func setLayout() {
        addSubviews(logoImage, verticalStackView)
        
        logoImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        verticalStackView.snp.makeConstraints {
            $0.leading.equalTo(logoImage.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}

