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

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var missionList: [DailyMissionResponseDTO] = []
    private var selectedDate: Date?
    private var userId: Int = 0
    var calendarDataSource: [String: Float] = [:]
    enum Sections: Int, Hashable {
        case mission, empty
    }
    var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private lazy var today: Date = { return Date() }()
    
    // MARK: - UI Components
    
    private lazy var missionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let weekCalendar = CalendarView(calendarScope: .week, scrollDirection: .horizontal)
    private let addButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: "yyyy-MM-dd", date: today))
        requestWeeklyMissoinAPI(startDate: Utils.dateFormatterString(format: "yyyy-MM-dd", date: today))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
        updateData()
    }
}

// MARK: - Methods

extension HomeViewController {
    
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
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: missionCollectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .mission:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCollectionViewCell.identifier, for: indexPath) as! MissionListCollectionViewCell
                cell.configure(model: item as! DailyMissionResponseDTO )
                cell.isTappedClosure = { result, id in
                    self.userId = id
                    if result {
                        self.requestPatchUpdateMissionAPI(id: self.userId, status: CompletionStatus.UNCHECKED )
                        cell.setUI()
                    } else {
                        self.requestPatchUpdateMissionAPI(id: self.userId, status: CompletionStatus.CHECKED )
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
    
    // MARK: - Layout
    
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
                return CompositionalLayout._vertical(.fractionalWidth(1), .fractionalHeight(1), .fractionalWidth(1), .fractionalHeight(1), count: 1, edge: nil)
            }
        }
        return layout
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { [unowned self] _, _, completion in
            print("delete")
            requestDeleteMission(id: self.userId)
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([self.missionList])
            snapshot.reloadSections([.mission])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completion(true)
        }
        
        let modifyAction = UIContextualAction(style: .normal, title: "") { _, _, completionHandler in
            print("modify")
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
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modalViewController = MissionDetailViewController()
        modalViewController.modalPresentationStyle = .overFullScreen
        modalViewController.userId = self.userId
        self.present(modalViewController, animated: true)
        
    }
}

extension HomeViewController {
    @objc
    func addBtnTapped(_sender: UIButton) {
        print("add button Tapped")
    }
    
    @objc
    func todayBtnTapped(_sender: UIButton) {
        weekCalendar.calendar.select(today)
        weekCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: today)
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: "YYYY-MM-dd", date: today))
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        weekCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
        requestWeeklyMissoinAPI(startDate: Utils.dateFormatterString(format: "YYYY-MM-dd", date: calendar.currentPage))
    }
    
    func  calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "EEEEEE", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        Utils.dateFormatterString(format: "dd", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        weekCalendar.yearMonthLabel.text = Utils.dateFormatterString(format: I18N.yearMonthTitle, date: date)
        requestDailyMissionAPI(date: Utils.dateFormatterString(format: "yyyy-MM-dd", date: date))
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: MissionCalendarCell.identifier, for: date, at: position) as! MissionCalendarCell
        let dateString = Utils.dateFormatterString(format: "yyyy-MM-dd", date: date)
        if let count = self.calendarDataSource[dateString] {
            print(count)
            switch count {
            case 0:
                cell.configure(.none, .week)
            case 1.0, 2.0:
                cell.configure(.rateHalf, .week)
            case 3:
                cell.configure(.rateFull, .week)
            default:
                cell.configure(.rateFull, .week)
            }
        }
        return cell
    }
}
extension HomeViewController {
    func requestDailyMissionAPI(date: String) {
        HomeAPI.shared.getDailyMission(date: date) { [weak self] result in
            switch result {
            case let .success(data):
                guard let data = data as? [DailyMissionResponseDTO] else {return}
                self?.missionList = []
                if !data.isEmpty {
                    for item in data {
                        self?.missionList = data
                        self?.userId = item.id
                    }
                }
                self?.updateData()
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .requestErr:
                print("networkFail")
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
                    print(self.calendarDataSource)
                }
                self.weekCalendar.calendar.reloadData()
            case .requestErr:
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
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
                    self?.updateData()
                } else {}
            }
        }
    }
    private func requestDeleteMission(id: Int) {
        HomeAPI.shared.deleteMission(id: id) { [weak self] _ in
            for index in 0..<(self?.missionList.count ?? 0) {
                if self?.missionList[index].id == id {
                    self?.missionList.remove(at: index)
                    self?.updateData()
                } else {}
            }
        }
    }
}
