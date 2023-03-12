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
    
    init(tag: String) {
        super.init(frame: .zero)
        setUI()
        setLayout()
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
        
    }
    private func setLayout() {
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(tag: String) {
        tagLabel.text = tag
    }
}
