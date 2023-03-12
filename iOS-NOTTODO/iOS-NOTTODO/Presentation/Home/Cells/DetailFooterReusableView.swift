//
//  DetailFooterReusableView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/12.
//

import UIKit

class DetailFooterReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "DetailFooterReusableView"
    
    // MARK: - UI Components

    private let dateLabel = UILabel()
    private let dateButton = UIButton()
    
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

// MARK: - Method

extension DetailFooterReusableView {
    private func setUI() {
        dateLabel.do {
            $0.text = "다른 날도 할래요"
        }
        dateButton.do {
            $0.configuration?.image = .icArrow
            $0.configuration?.title = "날짜 선택"
            $0.configuration?.imagePadding = 2
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
            $0.configuration?.attributedTitle?.font = .Pretendard(.medium, size: 16)
            $0.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        addSubviews(dateLabel, dateButton)
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29)
            $0.top.equalToSuperview().offset(33)
        }
        
        dateButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.top)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 86, height: 24))
        }
    }
    
    @objc
    private func dateButtonTapped() {
        print("tapped")
    }
}
