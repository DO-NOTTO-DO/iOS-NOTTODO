//
//  DetailAchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/14.
//

import UIKit

import Then
import SnapKit

final class DetailAchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
    typealias Item = DailyMissionResponseDTO
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, Hashable {
        case main
    }
    
    var selectedDate: Date?
    
    private var dataSource: DataSource?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedDate = selectedDate {
            requestDetailAPI(date: Utils.dateFormatterString(format: "YYYY-MM-dd",
                                                             date: selectedDate))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
        setLayout()
        setDataSource()
        setSnapShot()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !collectionView.frame.contains(location) {
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Achieve.closeDailyMissionModal)
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Methods

extension DetailAchievementViewController {

    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)

        collectionView.do {
            $0.collectionViewLayout = layout()
            $0.layer.cornerRadius = 15
            $0.backgroundColor = .white
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    private func setLayout() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(getDeviceWidth()*1.1)
        }
    }
    
    private func setDataSource() {
        
        let cellRegistration = CellRegistration<DetailAchievementCollectionViewCell, Item> {cell, _, item in
            cell.configure(model: item)
        }
        
        let headerRegistration = HeaderRegistration<DetailAchieveHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, _, _ in
            if let date = self.selectedDate {
                headerView.configure(text: Utils.dateFormatterString(format: "YYYY년 MM월 dd일",
                                                                     date: date))
            }
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
    }
    
    private func setSnapShot() {
        
        var snapShot = SnapShot()
        defer {
            dataSource?.apply(snapShot, animatingDifferences: false)
        }
        
        snapShot.appendSections([.main])
        snapShot.appendItems([], toSection: .main)
    }
    
    private func updateData(item: [DailyMissionResponseDTO]) {
        
        guard var snapshot = dataSource?.snapshot() else { return }
        
        snapshot.appendItems(item, toSection: .main)
        dataSource?.apply(snapshot)
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Achieve.appearDailyMissionModal(total: item.count))
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.backgroundColor = .clear
        config.separatorConfiguration.color = .gray5!
        config.separatorConfiguration.topSeparatorVisibility = .hidden
        config.separatorConfiguration.bottomSeparatorInsets = .init(top: 0,
                                                                    leading: 20,
                                                                    bottom: 0,
                                                                    trailing: 20)
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension DetailAchievementViewController {
    
    private func requestDetailAPI(date: String) {
        HomeAPI.shared.getDailyMission(date: date) { response in
            guard let response = response else { return }
            guard let data = response.data else { return }
            self.updateData(item: data)
        }
    }
}
