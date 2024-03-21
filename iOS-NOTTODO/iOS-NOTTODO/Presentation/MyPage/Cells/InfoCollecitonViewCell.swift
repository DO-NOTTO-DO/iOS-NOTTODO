//
//  InfoCollecitonViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import UIKit

import SnapKit
import Then

final class InfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "InfoCollectionViewCell"
    
    // MARK: - UI Components
    
    private let horizontalStackView = UIStackView()
    private let iconImage = UIImageView()
    private let titleLabel = UILabel()
    private let arrowImage = UIImageView()
    
    // MARK: - Life Cycle
    
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

extension InfoCollectionViewCell {
    
    private func setUI() {
        backgroundColor = .gray1
        
        titleLabel.do {
            $0.textColor = .white
            $0.font = .Pretendard(.regular, size: 14)
        }
        
        horizontalStackView.do {
            $0.addArrangedSubviews(iconImage, titleLabel)
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        arrowImage.do {
            $0.isHidden = true
            $0.image = .icRightArrow
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(horizontalStackView, arrowImage)
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(15)
        }
        
        iconImage.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerY.equalToSuperview()
        }
        
        arrowImage.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(13)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    func configureWithIcon(with model: MyPageRowData) {
        
        iconImage.image = model.image
        titleLabel.text = model.title
        
        horizontalStackView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(8)
        }
    }
    
    func configure(with model: MyPageRowData) {
        horizontalStackView.removeArrangedSubview(iconImage)
        iconImage.removeFromSuperview()
        titleLabel.text = model.title
        arrowImage.isHidden = false
    }
}
