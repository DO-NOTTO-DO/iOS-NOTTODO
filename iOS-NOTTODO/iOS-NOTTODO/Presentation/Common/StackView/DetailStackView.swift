//
//  DetailStackView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/12.
//

import UIKit

import Then
import SnapKit

class DetailStackView: UIView {
    
    private let verticalStackView = UIStackView()
    let tagLabel = UILabel()
    let titleLabel = UILabel()
    private let lineView = UIView()
    var isTop: Bool = true
    
    init(tag: String, isTop: Bool) {
        super.init(frame: .zero)
        setUI()
        setLayout(isTop: isTop)
        configure(tag: tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DetailStackView {
    private func setUI() {
        verticalStackView.do {
            $0.addArrangedSubviews(tagLabel, titleLabel)
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        tagLabel.do {
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 15)
        }
        
        titleLabel.do {
            $0.textColor = .black
            $0.font = .Pretendard(.medium, size: 16)
            $0.numberOfLines = 0
        }
        lineView.do {
            $0.backgroundColor = .gray5
        }
    }
    private func setLayout(isTop: Bool) {
        addSubviews(verticalStackView, lineView)
        
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        lineView.snp.makeConstraints {
            if isTop {
                $0.top.equalTo(verticalStackView.snp.top).offset(-25)
            } else {
                $0.top.equalTo(verticalStackView.snp.bottom).offset(35)
            }
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func configure(tag: String) {
        tagLabel.text = tag
    }
}
