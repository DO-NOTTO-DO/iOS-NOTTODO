//
//  AchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit
import Combine

import FSCalendar
import Then
import SnapKit

final class AchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let eventCellSubject = PassthroughSubject<Date, Never>()
    private let monthSubject = PassthroughSubject<Date, Never>()
    
    private weak var coordinator: AchieveCoordinator?
    private var dataSource: [String: Float] = [:]
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    private let viewModel: any AchievementViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let achievementLabel = UILabel()
    private let monthCalendar = CalendarView(scope: .month)
    private let statisticsView = StatisticsView()
    
    // MARK: - init
    
    init(viewModel: some AchievementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearSubject.send(())
        monthSubject.send(Date())
        monthCalendar.currentPage(date: Date())
        monthCalendar.configureYearMonth(to: Date().formattedString(format: I18N.yearMonthTitle))
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Achieve.viewAccomplish)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setBindings()
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
            $0.makeCornerRound(radius: 12)
            $0.makeBorder(width: 1, color: .gray4!)
            $0.configure(delegate: self, datasource: self)
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
    
    func setBindings() {
        let input = AchievementViewModelInput(viewWillAppearSubject: viewWillAppearSubject,
                                              calendarCellTapped: eventCellSubject,
                                              currentMonthSubject: monthSubject)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                self?.dataSource = item.percentages
                self?.monthCalendar.reloadCollectionView()
            }
            .store(in: &cancelBag)
    }
}

extension AchievementViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.monthSubject.send(calendar.currentPage)
        monthCalendar.configureYearMonth(to: calendar.currentPage.formattedString(format: I18N.yearMonthTitle))
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        date.formattedString(format: "dd")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor = .white
        
        if self.dataSource.contains(where: { $0.key == date.formattedString() }) {
            self.eventCellSubject.send(date)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        if let percentage = self.dataSource[date.formattedString()], percentage == 1.0 {
            return .black
        }
        return .white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let currentMonth = Calendar.current.component(.month, from: calendar.currentPage)
        let dateMonth = Calendar.current.component(.month, from: date)
        
        guard let percentage = self.dataSource[date.formattedString()] else {
            return currentMonth != dateMonth ? .gray3 : .white
        }
        return percentage == 1.0 ? .black : .white
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: MissionCalendarCell.identifier, for: date, at: position) as! MissionCalendarCell
        
        guard let percentage = self.dataSource[date.formattedString()] else { return cell }
        cell.configure(percent: percentage)
        
        return cell
    }
}
