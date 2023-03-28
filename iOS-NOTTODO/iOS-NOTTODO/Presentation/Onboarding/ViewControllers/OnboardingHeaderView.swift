//
//  OnboardingHeaderView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import SnapKit
import Then

class OnboardingHeaderView: UICollectionReusableView {
    
    static let identifier = "OnboardingHeaderView"
    
    private var isControl: Bool = false
    private let pageControl = UIImageView()
    private let pageControlLabel = UILabel()
    
    private let verticalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    let flagImage = UIImageView()
    private let goalLabel = UILabel()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(isControl: isControl)
        setLayout(isControl: isControl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension OnboardingHeaderView {
    private func setUI(isControl: Bool) {
        pageControl.do {
            $0.image = isControl ? .pageControlRight : .pageControlLeft
        }
        pageControlLabel.do {
            $0.text = isControl ? I18N.usePageControl : I18N.dailyPageControl
            $0.font = .Pretendard(.regular, size: 15)
            $0.textColor = .green1
        }
        verticalStackView.do {
            if isControl {
                $0.addArrangedSubviews(horizontalStackView, titleLabel)
            } else {
                $0.addArrangedSubviews(titleLabel, horizontalStackView)
            }
            $0.axis = .vertical
            $0.spacing = 13
        }
        horizontalStackView.do {
            if isControl {
                $0.addArrangedSubviews(flagImage, subTitleLabel)
            } else {
                $0.addArrangedSubview(subTitleLabel)
            }
            $0.axis = .horizontal
            $0.spacing = 6
        }
        titleLabel.do {
            $0.numberOfLines = 0
            $0.font = .Pretendard(.medium, size: 20)
            $0.textColor = .white
        }
        subTitleLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = isControl ? .green2 : .gray4
        }
        flagImage.do {
            $0.image = .icFlag
        }
    }
    
    private func setLayout(isControl: Bool) {
        addSubviews(pageControl, pageControlLabel, verticalStackView)
        
        pageControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.size.equalTo(CGSize(width: 27, height: 6))
            $0.centerX.equalToSuperview()
        }
        pageControlLabel.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(pageControlLabel.snp.bottom).offset(43)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        if isControl {
            titleLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(40)
            }
            horizontalStackView.snp.makeConstraints {
                $0.bottom.equalTo(titleLabel.snp.top).inset(20)
            }

            flagImage.snp.makeConstraints {
                $0.size.equalTo(20)
            }
        } else {
            horizontalStackView.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                $0.directionalHorizontalEdges.equalToSuperview()
            }
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.height.equalTo(50)
            }
        }
    }
    
    private func updateUI(title: String, subTitle: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    func configure(isControl: Bool, title: String, subTitle: String) {
        self.isControl = isControl
        updateUI(title: title, subTitle: subTitle)
        setLayout(isControl: isControl)
        setUI(isControl: isControl)
    }
}
