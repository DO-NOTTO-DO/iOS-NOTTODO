//
//  RecommendActionCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

class RecommendActionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendActionCollectionViewCell"
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.gray3?.cgColor : UIColor.clear.cgColor
            checkIcon.isHidden = isSelected ? false : true
        }
    }

    // MARK: - UI Components
    
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
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        
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
        contentView.addSubviews(titleLabel, bodyLabel, checkIcon)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        checkIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-27)
        }
    }
    
    func configure(model: RecommendActions) {
        titleLabel.text = model.name
        bodyLabel.text = model.description == nil ? "" : model.description
    }
}
