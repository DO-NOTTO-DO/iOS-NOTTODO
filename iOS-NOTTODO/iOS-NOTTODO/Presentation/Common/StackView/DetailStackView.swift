//
//  DetailStackView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/12.
//

import UIKit

import Then
import SnapKit

final class DetailStackView: UIView {
    
    let verticalStackView = UIStackView()
    let tagLabel = UILabel()
    let titleLabel = UILabel()
    let emptyIcon = UIImageView()
    private let lineView = UIView()
    var isTop: Bool = true
    
    init(tag: String, isTop: Bool, empty: UIImage) {
        super.init(frame: .zero)
        setUI(empty: empty)
        setLayout(isTop: isTop)
        configure(tag: tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DetailStackView {
    
    private func setUI(empty: UIImage) {
        verticalStackView.do {
            $0.addArrangedSubviews(tagLabel, titleLabel, emptyIcon)
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
        
        emptyIcon.do {
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
            $0.image = empty
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
        
        tagLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        emptyIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 185, height: 107))
        }
    }
    
    func configure(tag: String) {
        tagLabel.text = tag
    }
}
