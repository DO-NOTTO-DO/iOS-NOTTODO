//
//  AchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import FSCalendar
import Then
import SnapKit

final class AchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var today: Date = { return Date() }()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let achievementLabel = UILabel()
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let statisticsView = StatisticsView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension AchievementViewController {
    private func setUI() {
        view.backgroundColor = .ntdBlack
        scrollView.backgroundColor = .clear
        
        achievementLabel.do {
            $0.text = I18N.achievement
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
        monthCalendar.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray4?.cgColor
            $0.calendar.delegate = self
            $0.calendar.dataSource = self
        }
    }
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubviews(achievementLabel, monthCalendar, statisticsView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        achievementLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalTo(safeArea).offset(21)
        }
        
        monthCalendar.snp.makeConstraints {
            $0.top.equalTo(achievementLabel.snp.bottom).offset(22)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((getDeviceWidth()-30)*1.1)
        }
        
        statisticsView.snp.makeConstraints {
            $0.top.equalTo(monthCalendar.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((getDeviceWidth()-30)*0.6)
            $0.bottom.equalTo(scrollView.snp.bottom).inset(20)
        }
    }
}

extension AchievementViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthCalendar.yearMonthLabel.text = Utils.DateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.DateFormatterString(format: "dd", date: date)
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        calendar.appearance.selectionColor = .clear
        //        calendar.appearance.titleSelectionColor = .white
        print("선택")
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: true)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        Utils.calendarTitleColor(today: today, date: date, selected: false)

    }
}
