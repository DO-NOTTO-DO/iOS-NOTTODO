//
//  DetailHeaderReusableView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/13.
//

import UIKit

import SnapKit
import Then

final class DetailHeaderView: UIView {
    
    // MARK: - Properties
    
    var cancelClosure: (() -> Void)?
    var editClosure: (() -> Void)?
    
    // MARK: - UI Components

    private let cancelButton = UIButton()
    private let editButton = UIButton()
    
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

extension DetailHeaderView {
    
    private func setUI() {
        cancelButton.do {
            $0.backgroundColor = .clear
            $0.setImage(.icCancel, for: .normal)
            $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
        
        editButton.do {
            $0.setTitle(I18N.detailEdit, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
            $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        addSubviews(cancelButton, editButton)

        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().inset(24)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 44, height: 35))
            $0.trailing.equalToSuperview().inset(17)
        }
    }
    
    @objc
    func cancelButtonTapped() {
        cancelClosure?()
    }
    
    @objc
    func editButtonTapped() {
        editClosure?()
    }
}
