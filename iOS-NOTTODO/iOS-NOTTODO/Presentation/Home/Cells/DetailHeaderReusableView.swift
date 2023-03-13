//
//  DetailHeaderReusableView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/13.
//

import UIKit

class DetailHeaderReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "DetailHeaderReusableView"
    var cancelClosure: (() -> Void)?
    var editClosure: (() -> Void)?
    
    // MARK: - UI Components
    
    private let horizontalStackview = UIStackView()
    private let emptyView = UIView()
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

extension DetailHeaderReusableView {
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
        horizontalStackview.do {
            $0.addArrangedSubviews(cancelButton, emptyView, editButton)
            $0.axis = .horizontal
        }
    }
    
    private func setLayout() {
        addSubview(horizontalStackview)

        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().offset(7)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 44, height: 35))
        }
        horizontalStackview.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(17)
            $0.top.equalToSuperview().offset(-5)
            $0.height.equalTo(35)
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
