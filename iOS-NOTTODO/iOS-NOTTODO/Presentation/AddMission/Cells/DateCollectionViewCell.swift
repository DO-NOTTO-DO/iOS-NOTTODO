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
    
    // MARK: - Properties
    
    static let identifier = "DateCollectionViewCell"
    var missionCellHeight: ((CGFloat) -> Void)?
    var missionTextData: (([String]) -> Void)?
    private var fold: FoldState = .folded
    private lazy var today: Date = { return Date() }()
    private lazy var tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    private var dateList: [String] = []
    private var missionType: MissionType?
    
    // MARK: - UI Components
    
    private let titleLabel = TitleLabel(title: I18N.date)
    private let subTitleLabel = SubTitleLabel(subTitle: I18N.subDateTitle, colorText: nil)
    let calendarView = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let warningLabel = UILabel()
    
    private let stackView = UIStackView()
    private let foldStackView = UIStackView()
    private let paddingView = UIView()
    
    private var calendarImage = UIImageView()
    private var dateLabel = UILabel()
    private var dayLabel = UILabel()
    private var otherLabel = UILabel()
    private let foldStackViewPadding = UIView()
    
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
    
    func setCellData(_ dateArray: [String]) {
        let todayText = Utils.dateFormatterString(format: "yyyy.MM.dd", date: today)
        let tomorrowText = Utils.dateFormatterString(format: "yyyy.MM.dd", date: tomorrow)
        var dateArray = dateArray
        let checkToday = dateArray.contains(todayText)
        let checkTomorrow = dateArray.contains(tomorrowText)
        
        dateArray.sort(by: <)
        dateLabel.text = dateArray.first
        
        if checkToday {
            dayLabel.text = I18N.today
        } else if checkTomorrow {
            dayLabel.text = I18N.tomorrow
        } else {
            dayLabel.isHidden = checkToday && checkTomorrow
            paddingView.isHidden = !(checkToday && checkTomorrow)
        }
        
        otherLabel.isHidden = dateArray.count == 1 ? true : false
        if dateArray.count > 1 {
            otherLabel.text = "외 \(dateArray.count - 1)일"
        }
    }
}

extension DateCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear
        layer.borderColor = UIColor.gray3?.cgColor
        layer.cornerRadius = 12
        layer.borderWidth = 1
        calendarImage.image = .icCalendar
        dayLabel.font = .Pretendard(.medium, size: 15)
        stackView.axis = .vertical
        foldStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
        }
        
        dateLabel.do {
            $0.font = .Pretendard(.medium, size: 15)
            $0.textColor = .gray4
        }
        
        otherLabel.do {
            $0.font = .Pretendard(.regular, size: 15)
            $0.textColor = .white
        }
        
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
        foldStackView.addArrangedSubviews(titleLabel, dayLabel, paddingView, dateLabel, otherLabel, foldStackViewPadding, calendarImage)
        stackView.addArrangedSubviews(foldStackView, subTitleLabel, calendarView, warningLabel)
        contentView.addSubviews(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        stackView.do {
            $0.setCustomSpacing(10, after: foldStackView)
            $0.setCustomSpacing(0, after: subTitleLabel)
            $0.setCustomSpacing(13, after: calendarView)
        }
        
        foldStackView.do {
            $0.setCustomSpacing(36, after: titleLabel)
            $0.setCustomSpacing(10, after: dateLabel)
        }
        
        paddingView.snp.makeConstraints {
            $0.width.equalTo(9)
        }
        
        calendarImage.snp.makeConstraints {
            $0.size.equalTo(18)
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
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    private func updateUI() {
        let isHidden: Bool = ( fold == .folded )
        [subTitleLabel, calendarView, warningLabel].forEach {
            $0.isHidden = isHidden
        }
        [dayLabel, dateLabel, calendarImage, otherLabel].forEach { $0.isHidden = !isHidden }
        titleLabel.setTitleColor(isHidden)
        
        calendarImage.isHidden = missionType == .update
        
        backgroundColor = isHidden ? .clear : .gray1
        layer.borderColor = isHidden ? UIColor.gray2?.cgColor : UIColor.gray3?.cgColor
        stringToDate(dateList)
    }
    
    func stringToDate(_ dates: [String]) {
        var dateList: [Date] = []
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 0..<dates.count {
            if let date = dateFormatter.date(from: dates[i]) {
                dateList.append(date)
            } else {
                print("날짜 변환 실패")
            }
        }
        setDate(dateList)
    }
    
    private func setDate(_ dates: [Date]) {
        calendarView.setCalendarSelectedDate(dates)
    }
    
    func setDateList(_ dates: [String]) {
        dateList = dates
    }
    
    func setMissionType(_ type: MissionType) {
        missionType = type
        [dayLabel, otherLabel].forEach {
            $0.textColor = type == .update ? .gray4 : .white
        }
    }
}

extension DateCollectionViewCell: FSCalendarDelegate, FSCalendarDelegateAppearance {
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateList.append(Utils.dateFormatterString(format: "yyyy.MM.dd", date: date))
        missionTextData?((dateList))
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectDate = Utils.dateFormatterString(format: "yyyy.MM.dd", date: date)
        if let index = dateList.firstIndex(of: selectDate) {
            dateList.remove(at: index)
        }
        missionTextData?((dateList))
    }
}
