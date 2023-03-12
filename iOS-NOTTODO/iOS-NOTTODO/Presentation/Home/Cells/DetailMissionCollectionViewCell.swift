//
//  DetailMissionCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/12.
//

import UIKit

import Then
import SnapKit

class DetailMissionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let identifier = "DetailMissionCollectionViewCell"

    // MARK: - UI Components
    
    private let missionTagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let missionLabel = UILabel()
    private let accumulateView = UIView()
    private let accumulateSubView = UIView()
    private let accumulateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DetailMissionCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        
        missionTagLabel.do {
            $0.backgroundColor = .bg
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .gray1
        }
        
        missionLabel.do {
            $0.font = .Pretendard(.semiBold, size: 20)
            $0.textColor = .gray2
        }
        
        accumulateView.do {
            $0.backgroundColor = .green2?.withAlphaComponent(0.3)
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34
        }
        accumulateSubView.do {
            $0.backgroundColor = .green2
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 28
        }
        accumulateLabel.do {
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .Pretendard(.semiBold, size: 14)
            $0.numberOfLines = 2
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(missionTagLabel, missionLabel, accumulateView)
        accumulateView.addSubviews(accumulateSubView, accumulateLabel)
        
        missionTagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(29)
        }
        
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(missionTagLabel.snp.bottom).offset(10)
            $0.leading.equalTo(missionTagLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(30)
        }
        accumulateView.snp.makeConstraints {
            $0.top.equalTo(missionTagLabel.snp.top)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(68)
        }
        accumulateSubView.snp.makeConstraints {
            $0.center.centerY.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        accumulateLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func configure(model: MissionDetailModel) {
        missionTagLabel.text = model.tag
        missionLabel.text = model.mission
        accumulateLabel.text = "\(model.count)회\n달성"
    }
}
