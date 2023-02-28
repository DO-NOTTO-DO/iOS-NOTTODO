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
    private let verticalStackView = UIStackView()

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
        
        verticalStackView.do {
            $0.axis = .vertical
            $0.spacing = 33
            $0.distribution = .equalCentering
            $0.addArrangedSubviews(logoImage, emptyLabel)
        }
    }
    
    private func setLayout() {
        addSubviews(verticalStackView)
        
        logoImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 106, height: 70))
        }
        
        verticalStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(90)
            $0.directionalVerticalEdges.equalToSuperview().inset(112)
        }
    }
}
