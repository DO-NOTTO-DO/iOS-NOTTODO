//
//  HomeViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var coordinator: HomeCoordinator?
    private var missionList: [DailyMissionResponseDTO] = []
    private var calendarDataSource: [String: Float] = [:]
    
    private let today = Date()
    private var selectedDate: Date?
    private var current: Date?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private var didCloseButtonTap: Bool = false
    private var didDeprecatedButtonTap: Bool { return KeychainUtil.isDeprecatedBtnClicked() }
    
    // MARK: - UI Components
    
    private var missionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var missionDataSource = HomeDataSource(collectionView: missionCollectionView, missionList: missionList)
    
    private let weekCalendar = CalendarView(scope: .week)
    private let addButton = UIButton()
    
    // MARK: - init
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // showPopup(isSelected: didCloseButtonTap)
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.viewHome)
        
        dailyLoadData()
        weeklyLoadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension HomeViewController {
    
    private func setUI() {
        
        view.backgroundColor = .ntdBlack
        
        weekCalendar.do {
            $0.configure(delegate: self, datasource: self)
            $0.delegate = self
        }
        
        missionCollectionView.do {
            $0.backgroundColor = .bg
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.bounces = false
            $0.delegate = self
            $0.dataSource = missionDataSource.dataSource
        }
        
        addButton.do {
            $0.setImage(.addMission, for: .normal)
            $0.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        }
        
        missionDataSource.modalDelegate = self
        
    }
    
    private func setLayout() {
        
        view.addSubviews(weekCalendar, missionCollectionView, addButton)
        weekCalendar.select(date: today)
        
        weekCalendar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.height.equalTo(172)
        }
        
        missionCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekCalendar.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.width.height.equalTo(convertByHeightRatio(60))
            $0.trailing.equalTo(safeArea).inset(18)
            $0.bottom.equalTo(safeArea).inset(20)
        }
    }
}

// MARK: - Action

extension HomeViewController: WeekCalendarDelegate {
    
    @objc
    func addBtnTapped(_sender: UIButton) {
        
        let selectedDate = Utils.dateFormatterString(format: "yyyy.MM.dd", date: selectedDate ?? Date())
        coordinator?.showRecommendViewController(selectedDate: selectedDate)
    }
    
    func todayBtnTapped() {
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.clickReturnToday)
        
        weekCalendar.select(date: today)
        weekCalendar.configureYearMonth(to: Utils.dateFormatterString(format: I18N.yearMonthTitle, date: today))
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: nil, date: today))
    }
    
}

// MARK: - HomeModalDelegate

extension HomeViewController: HomeModalDelegate {
    
    func updateMissionStatus(id: Int, status: CompletionStatus) {
        
        self.requestPatchUpdateMissionAPI(id: id, status: status)
    }
    
    func modifyMission(id: Int, type: MissionType) {
        
        coordinator?.showModifyViewController(id: id, type: type)
    }
    
    func deleteMission(index: Int, id: Int) {
        
        coordinator?.showDeleteViewController { [weak self] in
            guard let self else { return }
            self.requestDeleteMission(index: index, id: id)
        }
    }
}

// MARK: - Collectionview Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !missionList.isEmpty {
            let id = missionList[indexPath.item].id
            
            coordinator?.showMissionDetailViewController(id: id, deleteClosure: { [weak self] in
                guard let self else { return }
                self.dailyLoadData()
                self.weeklyLoadData()
                self.missionDataSource.updateSnapShot(missionList: self.missionList )
            }, moveDateClosure: { [weak self] date in
                guard let self else { return }
                let modifiedDate: Date = date.toDate(withFormat: "YYYY.MM.dd")
                self.weekCalendar.select(date: modifiedDate)
                self.requestDailyMissionAPI(date: Utils.dateFormatterString(format: nil, date: modifiedDate))
            })
        }
    }
}

// MARK: - FSCalendar Delegate, DataSource, DelegateAppearance

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        updateCalendar(for: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.selectedDate = date
        
        weekCalendar.configureYearMonth(to: Utils.dateFormatterString(format: I18N.yearMonthTitle, date: date))
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: nil, date: date))
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.clickWeeklyDate(date: Utils.dateFormatterString(format: nil, date: date)))
    }
    
    func  calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "EEEEEE", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "dd", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return subtitleColorFor(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return subtitleColorFor(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: MissionCalendarCell.identifier, for: date, at: position) as? MissionCalendarCell else { return FSCalendarCell() }
        guard let percentage = getPercentage(for: date) else { return cell }
        cell.configure(percent: percentage)
        
        return cell
    }
}

// MARK: - Network

extension HomeViewController {
    
    func requestDailyMissionAPI(date: String) {
        
        MissionService.shared.getDailyMission(date: date) { [weak self] response in
            guard let self, let response = response, let data = response.data else { return }
            
            self.missionList = data
            self.missionDataSource.updateSnapShot(missionList: data)
        }
    }
    
    private func requestWeeklyMissoinAPI(startDate: String) {
        
        MissionService.shared.getWeeklyMissoin(startDate: startDate) { [weak self] response in
            guard let self, let response = response, let data = response.data else { return }
            
            let calendarData = data.compactMap { ($0.actionDate, $0.percentage) }
            self.calendarDataSource = Dictionary(uniqueKeysWithValues: calendarData)
            
            self.weekCalendar.reloadCollectionView()
        }
    }
    
    private func requestPatchUpdateMissionAPI(id: Int, status: CompletionStatus) {
        
        MissionService.shared.patchUpdateMissionStatus(id: id, status: status.rawValue) { [weak self] response in
            guard let self, let response = response, let data = response.data else { return }
            
            if let index = self.missionList.firstIndex(where: { $0.id == id }) {
                self.missionList[index] = data
                self.weeklyLoadData()
                self.missionDataSource.updateSnapShot(missionList: self.missionList)
            }
        }
    }
    
    private func requestDeleteMission(index: Int, id: Int) {
        MissionService.shared.deleteMission(id: id) { [weak self] _ in
            guard let self else { return }
            
            self.dailyLoadData()
            self.weeklyLoadData()
            self.missionDataSource.updateSnapShot(missionList: self.missionList)
            
            let data = self.missionList[index]
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickDeleteMission(section: "home",
                                                                                                  title: data.title,
                                                                                                  situation: data.situationName,
                                                                                                  goal: "",
                                                                                                  action: []))
            coordinator?.dismiss()
        }
    }
}

// MARK: - Others

extension HomeViewController {
    
    private func dailyLoadData() {
        
        let todayString = Utils.dateFormatterString(format: nil, date: self.selectedDate ?? today)
        requestDailyMissionAPI(date: todayString)
    }
    
    private func weeklyLoadData() {
        
        let sunday = getSunday(date: self.current ?? today)
        requestWeeklyMissoinAPI(startDate: Utils.dateFormatterString(format: nil, date: sunday))
    }
    
    private func getSunday(date: Date) -> Date {
        
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        comps.weekday = 1
        let sundayInWeek = cal.date(from: comps)!
        return sundayInWeek
    }
    
    private func getPercentage(for date: Date) -> Float? {
        
        let dateString = Utils.dateFormatterString(format: nil, date: date)
        return self.calendarDataSource[dateString]
    }
    
    private func updateCalendar(for date: Date) {
        
        self.current = date
        weekCalendar.configureYearMonth(to: Utils.dateFormatterString(format: I18N.yearMonthTitle, date: date))
        requestWeeklyMissoinAPI(startDate: Utils.dateFormatterString(format: nil, date: getSunday(date: date)))
    }
    
    private func subtitleColorFor(date: Date) -> UIColor {
        
        if let percentage = getPercentage(for: date) {
            return percentage == 1.0 ? .black : .white
        }
        
        return .white
    }
}

extension HomeViewController {
    
    private func showPopup(isSelected: Bool) {
        
        if !(isSelected || didDeprecatedButtonTap) {
            coordinator?.showPopupViewController { [weak self] in
                guard let self else { return }
                self.didCloseButtonTap = true
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.clickAdModalClose(again: self.didDeprecatedButtonTap ? "yes": "no" ))
            }
        }
    }
}
