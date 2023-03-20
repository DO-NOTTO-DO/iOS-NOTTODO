//
//  MissionHistoryCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

final class MissionHistoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MissionHistoryCollectionViewCell"
    
    // MARK: - UI Components
    
    private let missionHistoryLabel = UILabel()
    private let separatorView = UIView()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MissionHistoryCollectionViewCell {
    func setUI() {
        missionHistoryLabel.do {
            $0.font = .Pretendard(.medium, size: 14)
            $0.textColor = .bg
        }
        
        separatorView.do {
            $0.backgroundColor = .gray2
        }
    }
    
    func setLayout() {
        contentView.addSubviews(missionHistoryLabel, separatorView)
        
        missionHistoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(7)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        separatorView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(6)
            $0.height.equalTo(1)
            $0.bottom.equalTo(missionHistoryLabel.snp.top).offset(-8)
        }
    }
}

extension MissionHistoryCollectionViewCell {
    func configure(_ item: MissionHistoryModel) {
        missionHistoryLabel.text = item.missionTitle
    }
}
