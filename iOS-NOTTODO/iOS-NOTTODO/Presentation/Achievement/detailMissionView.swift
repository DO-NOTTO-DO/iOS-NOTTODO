//
//  detailMissionView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/14.
//

import UIKit

import SnapKit
import Then

class detailMissionView: UIView {
    
    // MARK: - Properties
        
    // MARK: - UI Components
    
    let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let horizontalStackView = UIStackView()
    private let emptyView = UIView()
    let titleLabel = UILabel()
    private let checkImage = UIImageView()
    private let lineView = UIView()
    
    // MARK: - View Life Cycle
    
    init(isHidden: Bool){
        super.init(frame: .zero)
        setUI(isHidden: isHidden)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension detailMissionView {
    private func setUI(isHidden: Bool) {
        layer.cornerRadius = 12
        
        tagLabel.do {
            $0.layer.backgroundColor = UIColor.bg?.cgColor
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .gray1
        }
        
        horizontalStackView.do {
            $0.addArrangedSubviews(titleLabel, emptyView, checkImage)
            $0.axis = .horizontal
        }
        
        titleLabel.do {
            $0.font = .Pretendard(.semiBold, size: 16)
            $0.textColor = .gray2
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        lineView.do {
            $0.backgroundColor = .gray5
            $0.isHidden = isHidden ? true : false
        }
    }
        
    private func setLayout() {
        addSubviews(tagLabel, horizontalStackView)
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(29)
        }
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
        }
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(7)
            $0.size.equalTo(21)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

