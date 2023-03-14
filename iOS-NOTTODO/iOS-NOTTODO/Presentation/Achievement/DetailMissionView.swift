//
//  detailMissionView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/14.
//

import UIKit

import SnapKit
import Then

class DetailMissionView: UIView {
    
    // MARK: - Properties
        
    // MARK: - UI Components
    
    let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let horizontalStackView = UIStackView()
    private let emptyView = UIView()
    let titleLabel = UILabel()
    private let checkImage = UIImageView()
    private let lineView = UIView()
    
    // MARK: - View Life Cycle
    
    init(tag: String, title: String, isHidden: Bool) {
        super.init(frame: .zero)
        setUI(tag: tag, title: title, isHidden: isHidden)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DetailMissionView {
    private func setUI(tag: String, title: String, isHidden: Bool) {
        layer.cornerRadius = 12
        
        tagLabel.do {
            $0.text = tag
            $0.layer.backgroundColor = UIColor.bg?.cgColor
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .gray1
            $0.layer.cornerRadius = 10
        }
        
        horizontalStackView.do {
            $0.addArrangedSubviews(titleLabel, emptyView, checkImage)
            $0.axis = .horizontal
        }
        
        titleLabel.do {
            $0.text = title
            $0.font = .Pretendard(.semiBold, size: 16)
            $0.textColor = .gray2
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        checkImage.do {
            $0.image = .checkboxFill
        }

        lineView.do {
            $0.backgroundColor = .gray5
            $0.isHidden = isHidden ? false : true
        }
    }
        
    private func setLayout() {
        addSubviews(lineView, tagLabel, horizontalStackView)
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(29)
        }
        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(7)
            $0.directionalHorizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(24)
        }

        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(7)
            $0.size.equalTo(21)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.top).offset(-22)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
    }
}
