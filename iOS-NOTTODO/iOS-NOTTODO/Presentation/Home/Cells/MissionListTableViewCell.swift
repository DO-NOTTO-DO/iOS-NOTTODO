//
//  MissionListTableViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/26.
//

import UIKit

import SnapKit
import Then

class MissionListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MissionListTableViewCell"
    
    // MARK: - UI Components
    
    private let checkButton = UIButton()
    private let verticalStackView = UIStackView()
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let missionLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    private let lineView = UIView()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MissionListTableViewCell {
    
    private func setUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        checkButton.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 6
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray4?.cgColor
        }
        
        tagLabel.do {
            $0.backgroundColor = .bg
            $0.layer.cornerRadius = 50
            $0.textColor = .gray1
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        missionLabel.do {
            $0.textColor = .gray2
            $0.font = .Pretendard(.semiBold, size: 16)
        }
        
        lineView.do {
            $0.isHidden = true
        }
        
        verticalStackView.do {
            $0.addArrangedSubviews(tagLabel, missionLabel)
            $0.axis = .vertical
            $0.spacing = 8
        }
    }
    
    func updateUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray5?.cgColor
        
        checkButton.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 6
            $0.setImage(.checkboxFill, for: .selected)
        }
        
        tagLabel.do {
            $0.backgroundColor = .gray6
            $0.layer.cornerRadius = 50
            $0.textColor = .gray4
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        missionLabel.do {
            $0.textColor = .gray4
            $0.font = .Pretendard(.semiBold, size: 16)
        }
        
        lineView.do {
            $0.backgroundColor = .gray4
            $0.isHidden = false
        }
        verticalStackView.do {
            $0.addArrangedSubviews(tagLabel, missionLabel)
            $0.axis = .vertical
            $0.spacing = 8
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(checkButton, verticalStackView)
        missionLabel.addSubview(lineView)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 21, height: 21))
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(checkButton.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
        }
    }
    
}
