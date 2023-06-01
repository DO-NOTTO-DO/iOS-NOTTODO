//
//  WithdrawModalView.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/01.
//

import UIKit
import SnapKit
import Then

final class WithdrawModalView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ModalDelegate?
    
    // MARK: - UI Components
    
    private let modalImageView = UIImageView()
    private let modalTitleLabel = UILabel()
    private let modalSubTitleLabel = UILabel()
    private var surveyButton = UIButton()

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

// MARK: - @objc Methods

extension WithdrawModalView {
    @objc
    func buttonDidTapped() {
        delegate?.modalAction()
    }
}

extension WithdrawModalView {
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        modalImageView.image = .quit2
        
        modalTitleLabel.do {
            $0.font = .Pretendard(.bold, size: 16)
            $0.textColor = .gray2
            $0.textAlignment = .center
            $0.text = I18N.withdrawModalTitle
            $0.numberOfLines = 0
        }
        
        modalSubTitleLabel.do {
            $0.font = .Pretendard(.regular, size: 13)
            $0.textColor = .gray4
            $0.textAlignment = .center
            $0.text = I18N.withdrawModalSubtitle
            $0.numberOfLines = 0
        }
        
        surveyButton.do {
            $0.setTitle(I18N.surveyButton, for: .normal)
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 7
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        addSubviews(modalImageView, modalTitleLabel, modalSubTitleLabel, surveyButton)
        
        modalImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(44)
            $0.trailing.equalToSuperview().inset(54)
            $0.height.equalTo(118)
        }
        
        modalTitleLabel.snp.makeConstraints {
            $0.top.equalTo(modalImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        modalSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(modalTitleLabel.snp.bottom).offset(19)
            $0.centerX.equalToSuperview()
        }
        
        surveyButton.snp.makeConstraints {
            $0.top.equalTo(modalSubTitleLabel.snp.bottom).offset(33)
            $0.directionalHorizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(17)
        }
    }
}
