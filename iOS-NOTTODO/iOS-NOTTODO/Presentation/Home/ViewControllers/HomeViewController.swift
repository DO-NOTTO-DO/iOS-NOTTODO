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
    
    private var missionList: [DailyMissionResponseDTO] = []
    private lazy var today: Date = { return Date() }()
    private var selectedDate: Date? // 눌렀을 떄 date - dailymissionAPI 호출 시 사용
    private var current: Date? // 스와이프했을 때 일요일 date 구하기 위함 - weeklyAPI 호출 시 사용
    private var count: Int?
    private var calendarDataSource: [String: Float] = [:]
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    enum Sections: Int, Hashable {
        case mission, empty
    }
    var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>! = nil
    
    // MARK: - UI Components
    
    private lazy var missionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let weekCalendar = CalendarView(calendarScope: .week, scrollDirection: .horizontal)
    private let addButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.viewHome)
        dailyLoadData()
        weeklyLoadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
    }
}

// MARK: - Methods

extension HomeViewController {
    
    private func dailyLoadData() {
        let todayString = Utils.dateFormatterString(format: nil, date: self.selectedDate ?? today)
        requestDailyMissionAPI(date: todayString)
    }
    
    private func weeklyLoadData() {
        let sunday = getSunday(date: self.current ?? today)
        requestWeeklyMissoinAPI(startDate: Utils.dateFormatterString(format: nil, date: sunday))
    }
    
    func getSunday(date: Date) -> Date {
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        comps.weekday = 1
        let sundayInWeek = cal.date(from: comps)!
        return sundayInWeek
    }
    
    private func register() {
        missionCollectionView.register(MissionListCollectionViewCell.self, forCellWithReuseIdentifier: MissionListCollectionViewCell.identifier)
        missionCollectionView.register(HomeEmptyCollectionViewCell.self, forCellWithReuseIdentifier: HomeEmptyCollectionViewCell.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        weekCalendar.do {
            $0.calendar.delegate = self
            $0.calendar.dataSource = self
            $0.calendar.register(MissionCalendarCell.self, forCellReuseIdentifier: MissionCalendarCell.identifier)
            $0.todayButton.addTarget(self, action: #selector(todayBtnTapped), for: .touchUpInside)
        }
        
        missionCollectionView.do {
            $0.backgroundColor = .bg
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.delegate = self
        }
        
        addButton.do {
            $0.setImage(.addMission, for: .normal)
            $0.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        view.addSubviews(weekCalendar, missionCollectionView, addButton)
        weekCalendar.calendar.select(today)
        
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
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: missionCollectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .mission:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCollectionViewCell.identifier, for: indexPath) as! MissionListCollectionViewCell
                cell.configure(model: item as! DailyMissionResponseDTO )
                cell.isTappedClosure = { [self] result, id in
                    if result {
                        self.requestPatchUpdateMissionAPI(id: id, status: CompletionStatus.UNCHECKED )
                        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.completeCheckMission(title: self.missionList[indexPath.row].title, situation: self.missionList[indexPath.row].situationName))
                        cell.setUI()
                    } else {
                        self.requestPatchUpdateMissionAPI(id: id, status: CompletionStatus.CHECKED )
                        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.completeCheckMission(title: self.missionList[indexPath.row].title, situation: self.missionList[indexPath.row].situationName))
                        cell.setUI()
                    }
                }
                return cell
            case .empty:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeEmptyCollectionViewCell.identifier, for: indexPath) as! HomeEmptyCollectionViewCell
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        defer {
            dataSource.apply(snapshot, animatingDifferences: false)
        }
        snapshot.appendSections([.empty])
        snapshot.appendItems([0], toSection: .empty)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateData() {
        var snapshot = dataSource.snapshot()
        if missionList.isEmpty {
            if snapshot.sectionIdentifiers.contains(.mission) {
                snapshot.deleteSections([.mission])
                snapshot.appendSections([.empty])
                snapshot.appendItems([0], toSection: .empty)
            } else if snapshot.sectionIdentifiers.contains(.empty) {
               
            } else {
                snapshot.appendSections([.empty])
                snapshot.appendItems([0], toSection: .empty)
            }
        } else {
            if snapshot.sectionIdentifiers.contains(.empty) {
                snapshot.deleteSections([.empty])
                snapshot.appendSections([.mission])
                snapshot.appendItems(missionList, toSection: .mission)
                
            } else if snapshot.sectionIdentifiers.contains(.mission) {
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .mission))
                snapshot.appendItems(missionList, toSection: .mission)
            } else {
                snapshot.appendSections([.mission])
                snapshot.appendItems(missionList, toSection: .mission)
            }
        }
        dataSource.apply(snapshot)
    }

    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvirnment  in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
            case .mission:
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.backgroundColor = .clear
                config.showsSeparators = false
                config.trailingSwipeActionsConfigurationProvider = self.makeSwipeActions
                
                let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvirnment)
                layoutSection.orthogonalScrollingBehavior = .none
                layoutSection.interGroupSpacing = 18
                layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 18)
                
                return layoutSection
                
            case .empty:
                return CompositionalLayout._vertical(.fractionalWidth(1), .fractionalWidth(1), .fractionalWidth(1), .fractionalWidth(1), count: 1, edge: .init(top: 30, leading: 0, bottom: 0, trailing: 0))
            }
        }
        return layout
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { [unowned self] _, _, completion in
            
            guard let index = indexPath?.item else { return }
            
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickDeleteMission(section: "home", title: self.missionList[index].title, situation: self.missionList[index].situationName, goal: "", action: []))
     
            let modalViewController = HomeDeleteViewController()
            modalViewController.modalPresentationStyle = .overFullScreen
            modalViewController.modalTransitionStyle = .crossDissolve
            modalViewController.deleteClosure = {
                self.requestDeleteMission(index: index)
            }
            present(modalViewController, animated: false)
            completion(true)
        }
        
        let modifyAction = UIContextualAction(style: .normal, title: "") { _, _, completionHandler in
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickEditMission(section: "home"))
            
            guard let index = indexPath?.item else { return }
            let id = self.missionList[index].id
            let updateMissionViewController = AddMissionViewController()
            updateMissionViewController.setMissionId(id)
            updateMissionViewController.setViewType(.update)
            Utils.push(self.navigationController, updateMissionViewController)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .ntdRed
        modifyAction.backgroundColor = .ntdBlue
        deleteAction.image = .icTrash
        modifyAction.image = .icFix
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, modifyAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}

// MARK: - Collectionview Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !missionList.isEmpty {
            let modalViewController = MissionDetailViewController()
            modalViewController.modalPresentationStyle = .overFullScreen
            modalViewController.userId = missionList[indexPath.item].id

            modalViewController.deleteClosure = { [weak self] in
                self?.dailyLoadData()
                self?.weeklyLoadData()
                self?.updateData()
            }
            modalViewController.moveDateClosure = { [weak self] date in
                let modifiedDate: Date = date.toDate(withFormat: "YYYY.MM.dd")
                self?.weekCalendar.calendar.select(modifiedDate)
                self?.requestDailyMissionAPI(date: Utils.dateFormatterString(format: nil, date: modifiedDate))
            }
            self.present(modalViewController, animated: true)
        }
    }
}

extension HomeViewController {
    
    @objc
    func addBtnTapped(_sender: UIButton) {
        let nextViewController = RecommendViewController()
        nextViewController.setSelectDate(Utils.dateFormatterString(format: "yyyy.MM.dd", date: selectedDate ?? Date()))
        Utils.push(navigationController, nextViewController)
    }
    
    @objc
    func todayBtnTapped(_sender: UIButton) {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.clickReturnToday)

        weekCalendar.calendar.select(today)
        weekCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: today)
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: nil, date: today))
    }
}

// MARK: - FSCalendar Delegate, DataSource, DelegateAppearance

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        weekCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
        self.current = calendar.currentPage
        let sunday = getSunday(date: calendar.currentPage)
        requestWeeklyMissoinAPI(startDate: Utils.dateFormatterString(format: nil, date: sunday))
    }
    
    func  calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "EEEEEE", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "dd", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        weekCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: date)
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: nil, date: date))
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.clickWeeklyDate(date: Utils.dateFormatterString(format: nil, date: date)))
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        guard let count = self.count else { return .white }
        let dateString = Utils.dateFormatterString(format: nil, date: date)
        if let percentage = self.calendarDataSource[dateString] {
            switch (count, percentage) {
            case (_, 1.0): return .black
            default: return .white
            }
        }
        return .white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        guard let count = self.count else { return .white }
        let dateString = Utils.dateFormatterString(format: nil, date: date)
        if let percentage = self.calendarDataSource[dateString] {
            switch (count, percentage) {
            case (_, 1.0): return .black
            default: return .white
            }
        }
        return .white
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: MissionCalendarCell.identifier, for: date, at: position) as! MissionCalendarCell
        guard let count = self.count else { return cell }
        let dateString = Utils.dateFormatterString(format: nil, date: date)
        if let percentage = self.calendarDataSource[dateString] {
            switch (count, percentage) {
            case (_, 1.0): cell.configure(.rateFull, .week)
            case (_, 0.0): cell.configure(.none, .week)
            case (2, 0.5), (3, 0.0..<1.0), (_, _): cell.configure(.rateHalf, .week)
            }
        }
        return cell
    }
}

// MARK: - Network

extension HomeViewController {
    
    func requestDailyMissionAPI(date: String) {
        HomeAPI.shared.getDailyMission(date: date) { [weak self] result in
            switch result {
            case let .success(data):
                guard let data = data as? [DailyMissionResponseDTO] else {return}
                self?.missionList = []
                if !data.isEmpty {
                    self?.missionList = data
                }
                self?.updateData()

            case .pathErr: print("pathErr")
            case .serverErr: print("serverErr")
            case .networkFail: print("networkFail")
            case .requestErr: print("networkFail")
            }
        }
    }
    
    private func requestWeeklyMissoinAPI(startDate: String) {
        HomeAPI.shared.getWeeklyMissoin(startDate: startDate) { result in
            switch result {
            case let .success(data):
                guard let data = data as? [WeekMissionResponseDTO] else { return }
                self.calendarDataSource = [:]
                for item in data {
                    self.calendarDataSource[item.actionDate] = item.percentage
                    self.count = self.calendarDataSource.count
                }
                self.weekCalendar.calendar.reloadData()
            case .requestErr: print("requestErr")
            case .pathErr: print("pathErr")
            case .serverErr: print("serverErr")
            case .networkFail: print("networkFail")
            }
        }
    }
    
    private func requestPatchUpdateMissionAPI(id: Int, status: CompletionStatus) {
        HomeAPI.shared.patchUpdateMissionStatus(id: id, status: status.rawValue) { [weak self] result in
            guard let result = result else { return }
            for index in 0..<(self?.missionList.count ?? 0) {
                if self?.missionList[index].id == id {
                    guard let data = result.data else { return }
                    self?.missionList[index] = data
                    self?.weeklyLoadData()
                    self?.updateData()
                } else {}
            }
        }
    }
    
    private func requestDeleteMission(index: Int) {
        let id = self.missionList[index].id
        HomeAPI.shared.deleteMission(id: id) { [weak self] _ in
            self?.dailyLoadData()
            self?.weeklyLoadData()
            self?.updateData()
            
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickDeleteMission(section: "home", title: (self?.missionList[index].title)!, situation: (self?.missionList[index].situationName)!, goal: "", action: []))
        }
    }
}
