//
//  MissionListCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/26.
//

import UIKit

import SnapKit
import Then

final class MissionListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MissionListCollectionViewCell"
    
    var userId: Int = 0
    var isTappedClosure: ((_ result: Bool, _ userId: Int) -> Void)?
    var isTapped: Bool = false {
        didSet {
            setUI()
        }
    }
    
    // MARK: - UI Components
    
    private let checkButton = UIButton()
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let missionLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    private let lineView = UIView()
    
    // MARK: - View Life Cycle

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        contentView.makeCornerRound(radius: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MissionListCollectionViewCell {
    
    func setUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.makeCornerRound(radius: 10)

        checkButton.do {
            $0.backgroundColor = .clear
            $0.setImage(UIImage.checkbox, for: .normal)
            $0.setImage(UIImage.checkboxFill, for: .selected)
            $0.addTarget(self, action: #selector(checkBoxButton), for: .touchUpInside)
        }
        
        tagLabel.do {
            $0.backgroundColor = .bg
            $0.clipsToBounds = true
            $0.makeCornerRound(radius: 12)
            $0.textColor = isTapped ? .gray7 : .gray1
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        missionLabel.do {
            $0.textColor = isTapped ? .gray7 : .gray2
            $0.font = .Pretendard(.semiBold, size: 16)
        }
        
        lineView.do {
            $0.backgroundColor = .gray7
            $0.isHidden = isTapped ? false : true
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(checkButton, tagLabel, missionLabel)
        missionLabel.addSubview(lineView)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(41)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(checkButton.snp.trailing).offset(8)
        }
        
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(8)
            $0.leading.equalTo(tagLabel.snp.leading).offset(-5)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    func configure(model: DailyMissionResponseDTO) {
        self.userId = model.id
        
        tagLabel.text = model.situationName
        missionLabel.text = model.title
        missionLabel.lineBreakMode = .byTruncatingTail
        
        switch model.completionStatus {
        case .UNCHECKED:  isTapped = false
        case .CHECKED: isTapped = true
        }
        
        checkButton.isSelected = isTapped
    }
    
    @objc
    func checkBoxButton(sender: UIButton) {
        isTappedClosure?(isTapped, userId)
    }
}
