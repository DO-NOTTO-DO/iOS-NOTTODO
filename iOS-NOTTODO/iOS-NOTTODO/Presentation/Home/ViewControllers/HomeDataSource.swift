//
//  HomeDataSource.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 11/19/23.
//

import UIKit

protocol HomeModalDelegate {
    
    func updateMissionStatus(id: Int, status: CompletionStatus)
    func modifyMission(id: Int, type: MissionType)
    func deleteMission(index: Int, id: Int)
}

final class HomeDataSource {
    
    // MARK: - Properties
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<Sections, Item>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, Item>
    
    enum Sections: Int, Hashable {
        
        case mission, empty
    }

    enum Item: Hashable {
        
        case mission(DailyMissionResponseDTO)
        case empty
    }
    
    private var currentSection: [Sections] = [.empty]
    private var missionList: [DailyMissionResponseDTO]
    
    var dataSource: DataSource?
    var modalDelegate: HomeModalDelegate?
    
    // MARK: - UI Components
    
    private let collectionView: UICollectionView
    
    init(collectionView: UICollectionView, missionList: [DailyMissionResponseDTO]) {
        self.collectionView = collectionView
        self.missionList = missionList
        
        setCollectionView()
        setDataSource()
        setSnapShot()
    }
    
    private func setCollectionView() {
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDataSource() {
        
        let cellRegistration = createMissionCellRegistration()
        let emptyRegistration = createEmptyCellRegistration()
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .mission:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            case .empty:
                return collectionView.dequeueConfiguredReusableCell(using: emptyRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            }
        })
    }
    
    private func createMissionCellRegistration() -> CellRegistration<MissionListCollectionViewCell, Item> {
        
        return CellRegistration { cell, _, item in
            guard let missionItem = self.getMissionItem(from: item) else { return }
            
            cell.configure(model: missionItem)
            
            cell.isTappedClosure = { [weak self] result, id in
                guard let self else { return }
                
                let status = result ? CompletionStatus.UNCHECKED : CompletionStatus.CHECKED
                self.modalDelegate?.updateMissionStatus(id: id, status: status)
                
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Home.completeCheckMission(title: missionItem.title, situation: missionItem.situationName))
            }
        }
    }
    
    private func createEmptyCellRegistration() -> CellRegistration<HomeEmptyCollectionViewCell, Item> {
        return CellRegistration { _, _, _ in }
    }
    
    private func setSnapShot() {
        
        var snapshot = SnapShot()
        
        defer {
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
        
        snapshot.appendSections([.empty])
        snapshot.appendItems([.empty], toSection: .empty)
    }
    
    func updateSnapShot(missionList: [DailyMissionResponseDTO]) {
        
        self.missionList = missionList
        guard var snapshot = dataSource?.snapshot() else { return }
        
        let newSections: [Sections] = self.missionList.isEmpty ? [.empty] : [.mission]
        let item: [Item] = self.missionList.isEmpty ? [.empty] : missionList.map { .mission($0) }
        
        snapshot.deleteSections(currentSection)
        snapshot.appendSections(newSections)
        snapshot.appendItems(item, toSection: newSections.first)
        
        currentSection = newSections
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else { return nil }
            
            switch section {
            case .mission:
                return self.missionSection(env: env)
            case .empty:
                return CompositionalLayout.vertical(count: 1, edge: .init(top: 30, leading: 0, bottom: 0, trailing: 0))
            }
        }
        return layout
    }
    
    private func missionSection(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .clear
        config.showsSeparators = false
        config.trailingSwipeActionsConfigurationProvider = self.makeSwipeActions
        
        let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 18)
        
        return section
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        
        guard let index = indexPath?.item,
              let result = findMissionItem(with: missionList[index].uuid) else { return nil }
        
        let indexPath = result.index
        let data = result.mission
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [unowned self] _, _, completion in
            
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickDeleteMission(section: "home",
                                                                                                  title: data.title,
                                                                                                  situation: data.situationName,
                                                                                                  goal: "",
                                                                                                  action: []))
            
            self.modalDelegate?.deleteMission(index: indexPath, id: data.id)
            completion(true)
        }
        
        let modifyAction = UIContextualAction(style: .normal, title: "") { _, _, completionHandler in
            
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickEditMission(section: "home"))
            
            self.modalDelegate?.modifyMission(id: data.id, type: .update)
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
    
    private func getMissionItem(from item: Item) -> DailyMissionResponseDTO? {
        if case let .mission(missionItem) = item {
            return missionItem
        }
        return nil
    }
    
    private func findMissionItem(with id: UUID) -> (index: Int, mission: DailyMissionResponseDTO)? {
        guard let index = missionList.firstIndex(where: { $0.uuid == id }) else {
            return nil
        }
        return (index, missionList[index])
    }
    
}
