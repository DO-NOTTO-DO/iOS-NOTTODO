//
//  DeleteModalView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/06/25.
//

import UIKit

import SnapKit
import Then

final class DeleteModalView: UIView {
    
    // MARK: - Properties
    
    var cancelClosure: (() -> Void)?
    var deleteClosure: (() -> Void)?
    
    // MARK: - UI Components
    
    private let trashImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let cancelButton = UIButton()
    private let deleteButton = UIButton()
    private let separateLineView = UIView()
    private let buttonStackView = UIStackView()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DeleteModalView {
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        
        trashImage.do {
            $0.image = .icTrashbin
        }
        
        titleLabel.do {
            $0.text = I18N.deleteModalTitle
            $0.font = .Pretendard(.semiBold, size: 15)
            $0.textColor = .gray3
        }
        
        subTitleLabel.do {
            $0.text = I18N.deleteModalSubtitle
            $0.font = .Pretendard(.regular, size: 13)
            $0.textColor = .gray4
        }
        
        cancelButton.do {
            $0.backgroundColor = .clear
            $0.setTitle(I18N.cancel, for: .normal)
            $0.setTitleColor(UIColor.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
            $0.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        }
        
        deleteButton.do {
            $0.backgroundColor = .clear
            $0.setTitle(I18N.delete, for: .normal)
            $0.setTitleColor(UIColor.ntdRed, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
            $0.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        }
        
        separateLineView.do {
            $0.backgroundColor = .gray6
        }
        
        buttonStackView.do {
            $0.addArrangedSubviews(cancelButton, separateLineView, deleteButton)
            $0.axis = .horizontal
            $0.spacing = 0
        }
    }
    
    private func setLayout() {
        addSubviews(trashImage, titleLabel, subTitleLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(cancelButton, separateLineView, deleteButton)
        
        trashImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(127)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(trashImage.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        separateLineView.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(self.snp.width).dividedBy(2)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
        }
    }
}

extension DeleteModalView {
    @objc
    private func didTapCancel() {
        self.cancelClosure?()
    }
    
    @objc
    private func didTapDelete() {
        self.deleteClosure?()
    }
}
