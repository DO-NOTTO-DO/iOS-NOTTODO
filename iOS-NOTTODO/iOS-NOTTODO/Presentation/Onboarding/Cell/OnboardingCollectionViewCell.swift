//
//  OnboardingCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import SnapKit
import Then

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "OnboardingCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.green1?.cgColor : UIColor.clear.cgColor
            contentView.backgroundColor = isSelected ? .gray2 : .gray1
        }
    }
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
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

extension OnboardingCollectionViewCell {
    private func setUI() {
        contentView.backgroundColor = .gray1
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        titleLabel.do {
            $0.font = .Pretendard(.regular, size: 15)
            $0.textColor = .white
            $0.textAlignment = .center
        }
    }
    
    private func setLayout() {
        addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func secondConfigure(model: SecondOnboardingModel) {
        titleLabel.text = model.title
    }
    
    func thirdConfigure(model: ThirdOnboardingModel) {
        titleLabel.text = model.title
    }
    
    func fiveConfigure(model: FifthOnboardingModel) {
        titleLabel.text = model.title
        titleLabel.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
