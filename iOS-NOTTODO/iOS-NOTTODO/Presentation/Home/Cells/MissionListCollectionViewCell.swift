//
//  MissionListCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/26.
//

import UIKit

import SnapKit
import Then

class MissionListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MissionListCollectionViewCell"
    
    var isTappedClosure: ((_ result: Bool) -> Void)?
    var isTapped: Bool = false
    
    // MARK: - UI Components
    
    private let checkButton = UIButton()
    private let tagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let missionLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    private let lineView = UIView()
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
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
        contentView.backgroundColor = isTapped ? .clear : .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = isTapped ? UIColor.gray5?.cgColor : UIColor.clear.cgColor
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.layer.cornerRadius = 10
        
        checkButton.do {
            $0.backgroundColor = isTapped ? .clear : .white
            $0.layer.cornerRadius = 6
            $0.layer.borderWidth = isTapped ? 0 : 0.5
            $0.layer.borderColor = isTapped ? UIColor.clear.cgColor : UIColor.gray4?.cgColor
            $0.setImage(isTapped ? UIImage.checkboxFill : nil, for: .normal)
            $0.addTarget(self, action: #selector(checkBoxButton), for: .touchUpInside)
        }
        
        tagLabel.do {
            $0.backgroundColor = isTapped ? .gray6 : .bg
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.textColor = isTapped ? .gray4 : .gray1
            $0.font = .Pretendard(.medium, size: 14)
        }
        
        missionLabel.do {
            $0.textColor = isTapped ? .gray4 : .gray2
            $0.font = .Pretendard(.semiBold, size: 16)
        }
        
        lineView.do {
            $0.backgroundColor = .gray4
            $0.isHidden = isTapped ? false : true
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(checkButton, tagLabel, missionLabel)
        missionLabel.addSubview(lineView)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 21, height: 21))
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(checkButton.snp.trailing).offset(18)
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
    
    func configure(model: MissionListModel) {
        tagLabel.text = model.tag
        missionLabel.text = model.missiontitle
    }
    
    @objc
    func checkBoxButton(sender: UIButton) {
        isTappedClosure?(true)
    }
}
