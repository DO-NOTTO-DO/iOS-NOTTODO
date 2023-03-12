//
//  HomeViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import Then
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let missionList: [MissionListModel] = MissionListModel.items
    enum Sections: Int, Hashable {
        case mission, empty
    }
    var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private lazy var missionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let popupView = PopUpView()
    
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
        
        missionCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.delegate = self
        }
    }
    
    private func setLayout() {
        view.addSubview(missionCollectionView)
        
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
        
        deleteAction.image = .checkboxFill
        modifyAction.image = .checkboxFill
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = MissionDetailViewController()
        detailViewController.modalPresentationStyle = .overFullScreen
        present(detailViewController, animated: false)
    }
}

extension CompositionalLayout {
    class func setUpSection(layoutEnvironment: NSCollectionLayoutEnvironment, mode: UICollectionLayoutListConfiguration.HeaderMode, _ top: CGFloat, _ bottom: CGFloat) -> NSCollectionLayoutSection {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = mode
        config.showsSeparators = true
        config.separatorConfiguration.color = UIColor.gray2!
        config.backgroundColor = .clear
        config.headerTopPadding = 22

        let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: top, leading: 0, bottom: bottom, trailing: 0)
        if config.headerMode == .supplementary {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(22))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        return section
    }
}
