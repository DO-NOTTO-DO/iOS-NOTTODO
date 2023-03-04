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
    private let dateFormatter = DateFormatter()
    
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
        view.backgroundColor = .bg
        
        dateFormatter.do {
            $0.locale = Locale(identifier: "ko_KR")
            $0.dateFormat = "YYYY년 MM월"
            $0.timeZone = TimeZone(identifier: "KST")
        }
        
        weekCalendar.do {
            $0.todayButton.addTarget(self, action: #selector(todayBtnTapped), for: .touchUpInside)
            $0.leftButton.addTarget(self, action: #selector(prevBtnTapped), for: .touchUpInside)
            $0.rightButton.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        }
        
        missionCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setLayout() {
        view.addSubviews(weekCalendar, missionCollectionView)
        
        weekCalendar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.height.equalTo(162)
        }
        
        missionCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(162)
            if missionList.isEmpty {
                $0.directionalHorizontalEdges.equalToSuperview()
            } else {
                $0.trailing.equalTo(safeArea).inset(18)
                $0.leading.equalTo(safeArea)
            }
            $0.bottom.equalTo(safeArea)
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
                layoutSection.contentInsets = .zero
                
                return layoutSection
                
            case .empty:
                return self.EmptySection()
            }
        }
        return layout
    }
    
    private func EmptySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.supplementariesFollowContentInsets = false
        
        return section
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
        
        deleteAction.image = .checkboxFill
        modifyAction.image = .checkboxFill
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
// MARK: - action

extension HomeViewController {
    @objc func todayBtnTapped(_sender : UIButton){
        weekCalendar.calendar.select(today)
        weekCalendar.yearMonthLabel.text = self.dateFormatter.string(from: today)
    }
    @objc func prevBtnTapped(_sender : UIButton){
        print("preTapped")
        Utils.scrollCurrentPage(calendar: weekCalendar.calendar , isPrev: true)
    }
    @objc func nextBtnTapped(_sender : UIButton){
        print("nextTapped")
        Utils.scrollCurrentPage(calendar: weekCalendar.calendar , isPrev: false)
    }
}
