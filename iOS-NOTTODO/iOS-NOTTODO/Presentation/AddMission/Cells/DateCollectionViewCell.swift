//
//  DateCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import Then
import FSCalendar

final class DateCollectionViewCell: UICollectionViewCell, AddMissionMenu {
    var missionTextData: ((String) -> Void)?
    func setCellData(_ text: String) {
        return
    }
    
    // MARK: - Properties
    
    var missionCellHeight: ((CGFloat) -> Void)?
    static let identifier = "DateCollectionViewCell"
    private var fold: FoldState = .folded
    private lazy var today: Date = { return Date() }()
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.date)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subDateTitle, colorText: nil)
    let calendarView = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let warningLabel = UILabel()
    private let stackView = UIStackView()
    
    private var calendarImage = UIImageView()
    private var dateLabel = UILabel()
    
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
        updateUI()
        contentView.layoutIfNeeded()
    }
}

private extension DateCollectionViewCell {
    
    private func setUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        calendarImage.image = .icCalendar
        stackView.axis = .vertical
        
        warningLabel.do {
            $0.text = I18N.dateWarning
            $0.font = .Pretendard(.regular, size: 13)
            $0.textColor = .gray4
            $0.numberOfLines = 0
        }
        
        calendarView.do {
            $0.calendar.backgroundColor = .clear
            $0.backgroundColor = .clear
            $0.calendar.delegate = self
        }
    }
    
    private func setLayout() {
        stackView.addArrangedSubviews(titleLabel, subTitleLabel, calendarView, warningLabel)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: titleLabel)
            $0.setCustomSpacing(0, after: subTitleLabel)
            $0.setCustomSpacing(13, after: calendarView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(6)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        calendarView.snp.makeConstraints {
            $0.height.equalTo((UIScreen.main.bounds.size.width-60)*1.05)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        calendarView.calendar.snp.updateConstraints {
            $0.bottom.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(13)
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = ( fold == .folded )
        [subTitleLabel, calendarView, warningLabel].forEach {
            $0.isHidden = isHidden
        }
        
        titleLabel.setTitleColor(isHidden)
        
        backgroundColor = isHidden ? .clear : .gray1
        layer.borderColor = isHidden ? UIColor.gray2?.cgColor : UIColor.gray3?.cgColor
    }
}

extension DateCollectionViewCell: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarView.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        switch Calendar.current.compare(today, to: date, toGranularity: .day) {
        case .orderedSame:
            print("\(date) is the same as \(today)")
            return true
        case .orderedDescending:
            print("\(date) is before \(today)")
            return false
        case .orderedAscending:
            print("\(date) is after \(today)")
            let sevenDays = Calendar.current.date(byAdding: .day, value: +6, to: Date())!
            if date < sevenDays {
                return true
            }
            return false
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: false)
    }
}
