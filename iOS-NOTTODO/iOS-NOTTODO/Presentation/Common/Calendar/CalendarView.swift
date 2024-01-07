//
//  CalendarView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import UIKit

import FSCalendar
import Then
import SnapKit

final class CalendarView: UIView {
    
    // MARK: - UI Components

    let yearMonthLabel = UILabel()
    let todayButton = UIButton(configuration: .filled())
    let horizonStackView = UIStackView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    var calendar = WeekMonthFSCalendar()
    private lazy var today: Date = { return Date() }()
    var monthCalendarClosure: ((_ month: String) -> Void)?
    
    // MARK: - Life Cycle
    
    init(calendarScope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        super.init(frame: .zero)
        setCalendar(scope: calendarScope, scrollDirection: scrollDirection)
        setUI()
        setLayout(scope: calendarScope)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CalendarView {
    
    private func setCalendar(scope: FSCalendarScope, scrollDirection: FSCalendarScrollDirection) {
        calendar = WeekMonthFSCalendar(calendarScope: scope, scrollDirection: scrollDirection)
    }
    
    private func setUI() {
        backgroundColor = .ntdBlack
        
        yearMonthLabel.do {
            $0.font = .Pretendard(.medium, size: 18)
            $0.textColor = .white
            $0.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: Date())
        }
        
        todayButton.do {
            $0.configuration?.image = .icBackToday
            $0.configuration?.title = I18N.todayButton
            $0.configuration?.imagePadding = 2
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 3, leading: 6, bottom: 2, trailing: 7)
            $0.configuration?.cornerStyle = .capsule
            $0.configuration?.attributedTitle?.font = .Pretendard(.regular, size: 14)
            $0.configuration?.baseBackgroundColor = .gray2
            $0.configuration?.baseForegroundColor = .gray5
        }
        horizonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        
        leftButton.do {
            $0.setImage(.calendarLeft, for: .normal)
            $0.addTarget(self, action: #selector(prevBtnTapped), for: .touchUpInside)
        }
        
        rightButton.do {
            $0.setImage(.calendarRight, for: .normal)
            $0.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout(scope: FSCalendarScope) {
        switch scope {
        case .week:
            addSubviews(calendar, yearMonthLabel, todayButton)
            
            yearMonthLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(23)
                $0.leading.equalToSuperview().offset(20)
            }
            
            todayButton.snp.makeConstraints {
                $0.top.equalTo(yearMonthLabel.snp.top)
                $0.trailing.equalToSuperview().inset(18)
                $0.size.equalTo(CGSize(width: 60, height: 30))
            }
            
            calendar.snp.makeConstraints {
                $0.top.equalTo(yearMonthLabel.snp.bottom).offset(8)
                $0.directionalHorizontalEdges.equalToSuperview().inset(11)
                $0.bottom.equalToSuperview().inset(20)
            }
        case .month:
            addSubviews(horizonStackView, calendar)
            horizonStackView.addArrangedSubviews(leftButton, yearMonthLabel, rightButton)

            leftButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            rightButton.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 25, height: 25))
            }
            
            horizonStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(25)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(25)
            }
            
            calendar.snp.makeConstraints {
                $0.top.equalTo(horizonStackView.snp.bottom).offset(20)
                $0.directionalHorizontalEdges.equalToSuperview().inset(15)
                $0.bottom.equalToSuperview().inset(25)
            }
        @unknown default:
            return
        }
    }
    
    func scrollCurrentPage(calendar: WeekMonthFSCalendar, isPrev: Bool) {
        let gregorian = Calendar(identifier: .gregorian)
        calendar.setCurrentPage( gregorian.date(byAdding: calendar.scope == .week ? .weekOfMonth : .month, value: isPrev ? -1 : 1, to: calendar.currentPage)!, animated: true)
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "yyyy-MM"
        let stringDate = monthDateFormatter.string(from: calendar.currentPage)
        monthCalendarClosure?(stringDate)
    }
}

// MARK: - Action

extension CalendarView {

    @objc
    func prevBtnTapped(_sender: UIButton) {
        scrollCurrentPage(calendar: calendar, isPrev: true)
    }
    
    @objc
    func nextBtnTapped(_sender: UIButton) {
        scrollCurrentPage(calendar: calendar, isPrev: false)
    }
}

extension CalendarView {
    
    func setCalendarSelectedDate(_ dates: [Date]) {
        dates.forEach {
            calendar.select($0)
        }
    }
    
    func configure(delegate: FSCalendarDelegate, datasource: FSCalendarDataSource) {
        calendar.delegate = delegate
        calendar.dataSource = datasource
    }
    
    func configureYearMonth(to text: String) {
        yearMonthLabel.text = text
    }
    
    func reloadCollectionView() {
        calendar.collectionView.reloadData()
    }
    
    func updateDetailConstraints() {
        horizonStackView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(54)
        }
        calendar.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(45)
        }
    }
    
}
