//
//  DateCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import Then

final class DateCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    
    // MARK: - Properties
    
    var missionCellHeight: ((CGFloat) -> Void)?
    static let identifier = "DateCollectionViewCell"
    private var fold: FoldState = .folded
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.date)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subDateTitle, colorText: nil)
    // 캘린더뷰가 들어갈 공간
    private let calendarView = UIView()
    private let warningLabel = UILabel()
    
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
    
    func setFoldState(_ state: FoldState) {
        fold = state
        missionCellHeight?(state == .folded ? 54 : 470)
        updateLayout()
        updateUI()
        contentView.layoutIfNeeded()
    }
}

private extension DateCollectionViewCell {
    
    private func setUI() {
        backgroundColor = .gray1
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        
        warningLabel.do {
            $0.text = I18N.dateWarning
            $0.font = .Pretendard(.regular, size: 13)
            $0.textColor = .gray4
        }
        
        calendarView.backgroundColor = .cyan
    }
    
    private func setLayout() {
        contentView.addSubviews(titleLabel, subTitleLabel, calendarView, warningLabel)
        updateLayout()
        updateUI()
    }
    
    private func updateLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(21)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(23)
        }
        
        calendarView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(27)
            $0.width.equalToSuperview().inset(16)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(13)
            $0.leading.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = ( fold == .folded )
        [titleLabel, subTitleLabel, calendarView, warningLabel].forEach {
            $0.isHidden = isHidden
        }
    }
}
