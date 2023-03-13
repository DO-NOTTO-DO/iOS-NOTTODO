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
    
    private let missionList: [MissionListModel] = MissionListModel.items
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
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
                cell.configure(model: item as! MissionListModel )
                cell.isTappedClosure = { result in
                    if result {
                        cell.isTapped.toggle()
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
        var snapShot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        
        if missionList.isEmpty {
            snapShot.appendSections([.empty])
            snapShot.appendItems([0], toSection: .empty)
        } else {
            snapShot.appendSections([.mission])
            snapShot.appendItems(missionList, toSection: .mission)
        }
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
        let deleteAction = UIContextualAction(style: .normal, title: "") { _, _, completion in
            print("delete")
            completion(true)
        }
        
        let modifyAction = UIContextualAction(style: .normal, title: "") { _, _, completionHandler in
            print("modify")
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .ntdBlue
        modifyAction.backgroundColor = .ntdRed
        
        deleteAction.image = .icTrash
        modifyAction.image = .icFix
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Utils.Modal(self, MissionDetailViewController(), .overFullScreen)
    }
}

extension HomeViewController {
    @objc
    func addBtnTapped(_sender: UIButton) {
        print("add button Tapped")
    }
}
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        weekCalendar.yearMonthLabel.text = Utils.DateFormatterString(format: I18N.yearMonthTitle, date: calendar.currentPage)
    }
    
    func  calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        Utils.DateFormatterString(format: "EEEEEE", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        Utils.DateFormatterString(format: "dd", date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        weekCalendar.yearMonthLabel.text = Utils.DateFormatterString(format: I18N.yearMonthTitle, date: date)
        print("선택")
    }
}
