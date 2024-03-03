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
    
    private weak var coordinator: AchieveCoordinator?
    private var currentPage = Date()
    private var dataSource: [String: Float] = [:]
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let achievementLabel = UILabel()
    private let monthCalendar = CalendarView(calendarScope: .month, scrollDirection: .horizontal)
    private let statisticsView = StatisticsView()
    
    // MARK: - init
    init(coordinator: AchieveCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Achieve.viewAccomplish)
        
        if let today = monthCalendar.calendar.today {
            monthCalendar.configureYearMonth(to: Utils.dateFormatterString(format: I18N.yearMonthTitle, date: today))
            monthCalendar.calendar.currentPage = today
            requestMonthAPI(month: Utils.dateFormatterString(format: "yyyy-MM", date: today))
        }
    }
    
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
        
        scrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
        
        achievementLabel.do {
            $0.text = I18N.achievement
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
        
        monthCalendar.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray4?.cgColor
            $0.calendar.register(MissionCalendarCell.self, forCellReuseIdentifier: MissionCalendarCell.identifier)
            $0.calendar.delegate = self
            $0.calendar.dataSource = self
            $0.monthCalendarClosure = { [weak self] month in
                guard let self else { return }
                self.requestMonthAPI(month: month)
            }
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
            $0.height.equalTo((Numbers.width-30)*1.1)
        }
        
        statisticsView.snp.makeConstraints {
            $0.top.equalTo(monthCalendar.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo((Numbers.width-30)*0.6)
            $0.bottom.equalTo(scrollView.snp.bottom).inset(20)
        }
    }
}

extension AchievementViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.currentPage = calendar.currentPage
        requestMonthAPI(month: Utils.dateFormatterString(format: "yyyy-MM", date: calendar.currentPage))
        monthCalendar.configureYearMonth(to: Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage))
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "dd", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor = .white
        let dateString = Utils.dateFormatterString(format: "yyyy-MM-dd", date: date)
        if self.dataSource.contains(where: { $0.key == dateString }) {
            coordinator?.showAchieveDetailViewController(selectedDate: date)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        Calendar.current.isDate(date, equalTo: calendar.currentPage, toGranularity: .month)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        titleColorFor(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let currentMonth = Calendar.current.component(.month, from: currentPage)
        let dateMonth = Calendar.current.component(.month, from: date)
        
        if let percentage = getPercentage(for: date) {
            return percentage == 1.0 ? .black : .white
        } else {
            return currentMonth != dateMonth ? .gray3 : .white
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: MissionCalendarCell.identifier, for: date, at: position) as! MissionCalendarCell
        
        guard let percentage = getPercentage(for: date) else { return cell }
        cell.configure(percent: percentage)
        
        return cell
    }
}

// MARK: - Others

extension AchievementViewController {
    
    func requestMonthAPI(month: String) {
        AchieveAPI.shared.getAchieveCalendar(month: month) { [weak self] response in
            
            guard let self, let response = response, let data = response.data else { return }
            
            let calendarData = data.compactMap { ($0.actionDate, $0.percentage) }
            self.dataSource = Dictionary(uniqueKeysWithValues: calendarData)
            self.monthCalendar.calendar.collectionView.reloadData()
        }
    }
    
    private func getPercentage(for date: Date) -> Float? {
        
        let dateString = Utils.dateFormatterString(format: nil, date: date)
        return self.dataSource[dateString]
    }
    
    private func titleColorFor(date: Date) -> UIColor {
        
        if let percentage = getPercentage(for: date) {
            return percentage == 1.0 ? .black : .white
        }
        
        return .white
    }
}
