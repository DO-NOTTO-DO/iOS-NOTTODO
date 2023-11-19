//
//  InfoCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
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
        
        iconImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        arrowImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(13)
        }
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.bottom.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureWithIcon(with model: InfoModel) {
        
        iconImage.image = model.image
        titleLabel.text = model.title
        
        horizontalStackView.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(8)
        }
    }
    
    func configure(with model: InfoModel, isHidden: Bool) {
        horizontalStackView.removeArrangedSubview(iconImage)
        iconImage.removeFromSuperview()
        titleLabel.text = model.title
        arrowImage.isHidden = isHidden
    }
}
