//
//  RecommendActionCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

final class RecommendActionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendActionCollectionViewCell"
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.gray3?.cgColor : UIColor.clear.cgColor
            checkIcon.isHidden = !isSelected 
        }
    }

    // MARK: - UI Components
    
    private let stackView = UIStackView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    private let checkIcon = UIImageView()
    
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
        contentView.makeCornerRound(radius: 10)
        contentView.makeBorder(width: 1, color: .clear)
        stackView.axis = .vertical
        
        titleLabel.do {
            $0.font = .Pretendard(.regular, size: 15)
            $0.textColor = .white
        }
        
        bodyLabel.do {
            $0.font = .Pretendard(.regular, size: 12)
            $0.textColor = .gray4
            $0.numberOfLines = 0
        }
        
        checkIcon.do {
            $0.image = .icChecked
            $0.isHidden = true
        }
    }
    
    private func setLayout() {
        stackView.addArrangedSubviews(titleLabel, bodyLabel)
        contentView.addSubviews(stackView, checkIcon)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.do {
            $0.setCustomSpacing(7, after: titleLabel)
            $0.setCustomSpacing(16, after: bodyLabel)
        }
                
        checkIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(model: RecommendActions) {
        titleLabel.text = model.name
        bodyLabel.text = model.description == nil ? "" : model.description
    }
}
