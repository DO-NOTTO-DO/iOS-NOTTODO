//
//  QuitModalView.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/01.
//

import UIKit
import SnapKit
import Then

final class QuitModalView: UIView {
    
    private let modalImageView = UIImageView()
    private let modalTitleLabel = UILabel()
    private let modalSubTitleLabel = UILabel()
    private let cancelButton = UIButton()
    private let withdrawButton = UIButton()
    private let separateLineView = UIView()
    private let buttonStackView = UIStackView()

    // MARK: - View Life Cycle
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuitModalView {
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        
        modalImageView.image = .quit1
        
        modalTitleLabel.do {
            $0.font = .Pretendard(.bold, size: 16)
            $0.textAlignment = .center
            $0.text = I18N.quitModalTitle
            $0.numberOfLines = 0
        }
        
        modalSubTitleLabel.do {
            $0.font = .Pretendard(.regular, size: 13)
            $0.textAlignment = .center
            $0.text = I18N.quitModalSubtitle
            $0.numberOfLines = 0
        }
        
        cancelButton.do {
            $0.backgroundColor = .clear
            $0.setTitle(I18N.cancel, for: .normal)
            $0.setTitleColor(UIColor.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
        }
        
        withdrawButton.do {
            $0.backgroundColor = .clear
            $0.setTitle(I18N.withdraw, for: .normal)
            $0.setTitleColor(UIColor.ntdRed, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
        }
        
        separateLineView.do {
            $0.backgroundColor = .gray6
        }
        
        buttonStackView.do {
            $0.addArrangedSubviews(cancelButton, separateLineView, withdrawButton)
            $0.axis = .horizontal
            $0.spacing = 0
        }
    }
    
    private func setLayout() {
        addSubviews(modalImageView, modalTitleLabel, modalSubTitleLabel, buttonStackView)
        
        modalImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.equalToSuperview().inset(63)
            $0.trailing.equalToSuperview().inset(57)
            $0.height.equalTo(104)
        }
        
        modalTitleLabel.snp.makeConstraints {
            $0.top.equalTo(modalImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        modalSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(modalTitleLabel.snp.bottom).offset(19)
            $0.centerX.equalToSuperview()
        }
        
        separateLineView.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(self.snp.width).dividedBy(2)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(modalSubTitleLabel.snp.bottom).offset(26)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
        }
    }
}
