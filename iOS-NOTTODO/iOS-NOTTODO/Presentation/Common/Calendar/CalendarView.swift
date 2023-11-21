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

protocol CalendarViewDelegate {
    
    func todayBtnTapped()
}

final class CalendarView: UIView {
    
    // MARK: - Properties
    
    let today = Date()
    var monthCalendarClosure: ((_ month: String) -> Void)?
    var delegate: CalendarViewDelegate?
    
    // MARK: - UI Components

    private let yearMonthLabel = UILabel()
    let todayButton = UIButton(configuration: .filled())
    private let horizonStackView = UIStackView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
     var calendar = WeekMonthFSCalendar()
    
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
            var config = UIButton.Configuration.filled()
            config.image = .icBackToday
            config.title = I18N.todayButton
            config.imagePadding = 2
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 3, leading: 6, bottom: 2, trailing:7)
            config.cornerStyle = .capsule
            config.attributedTitle?.font = .Pretendard(.regular, size: 14)
            config.baseBackgroundColor = .gray2
            config.baseForegroundColor = .gray5
            
            $0.configuration = config
            $0.addTarget(self, action: #selector(todayBtnTapped), for: .touchUpInside)
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
        
        calendar.do {
            $0.collectionView.register(MissionCalendarCell.self,
                                       forCellWithReuseIdentifier: MissionCalendarCell.identifier)
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
            
            [leftButton, rightButton].forEach {
                $0.snp.makeConstraints {
                    $0.size.equalTo(CGSize(width: 25, height: 25))
                }
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

extension CalendarView {

    @objc
    func prevBtnTapped(_sender: UIButton) {
        scrollCurrentPage(calendar: calendar, isPrev: true)
    }
    
    @objc
    func nextBtnTapped(_sender: UIButton) {
        scrollCurrentPage(calendar: calendar, isPrev: false)
    }
    
    @objc
    func todayBtnTapped(_sender: UIButton) {
        delegate?.todayBtnTapped()
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
