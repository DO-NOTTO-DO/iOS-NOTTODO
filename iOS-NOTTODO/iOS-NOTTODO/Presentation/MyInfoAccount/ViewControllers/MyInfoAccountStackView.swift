//
//  MyInfoAccountStackView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/18.
//

import UIKit

import SnapKit
import Then

class MyInfoAccountStackView: UIView {
        
    // MARK: - UI Components
    
    private let horizontalStackView = UIStackView()
    private let emptyView = UIView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let notificationSwitch = UISwitch()
    private let lineView = UIView()
    var isTapped: Bool = false
    var switchClosure: ((_ isTapped: Bool) -> Void)?
    
    // MARK: - View Life Cycle
    
    init(title: String, isHidden: Bool) {
        super.init(frame: .zero)
        setUI(title: title, isHidden: isHidden)
        setLayout(isHidden: isHidden)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MyInfoAccountStackView {
    private func setUI(title: String, isHidden: Bool) {
        layer.cornerRadius = 10
        
        horizontalStackView.do {
            $0.addArrangedSubviews(titleLabel, emptyView, isHidden ? notificationSwitch : contentLabel)
            $0.axis = .horizontal
        }
        
        titleLabel.do {
            $0.text = title
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .white
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        contentLabel.do {
            $0.font = .Pretendard(.regular, size: 14)
            $0.textColor = .gray6
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        notificationSwitch.do {
            $0.isOn = true
            $0.onTintColor = .green2
            $0.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        }
        
        lineView.do {
            $0.backgroundColor = .gray2
            $0.isHidden = isHidden ? true : false
        }
    }
        
    private func setLayout(isHidden: Bool) {
        addSubviews(lineView, horizontalStackView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        if !isHidden {
            contentLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
            }
        } else {
            notificationSwitch.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(30)
                $0.width.equalTo(50)
            }
        }
        
        lineView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    @objc func switchTapped(_ sender: Any) {
        isTapped.toggle()
        switchClosure?(isTapped)
    }
}
