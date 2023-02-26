//
//  HomeViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let missionList: [MissionListModel] = MissionListModel.items
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    enum Section: Int, Hashable {
        case mission
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MissionListModel>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
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

extension HomeViewController {
    
    private func register() {
        collectionView.register(MissionListCollectionViewCell.self, forCellWithReuseIdentifier: MissionListCollectionViewCell.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .bg
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(162)
            $0.trailing.equalTo(safeArea).inset(18)
            $0.leading.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
    }
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MissionListModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCollectionViewCell.identifier, for: indexPath) as? MissionListCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(model: item)
            cell.isTappedClosure = { result in
                if result {
                    cell.isTapped.toggle()
                    cell.setUI()
                }
            }
            return cell
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MissionListModel>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.mission])
        snapShot.appendItems(missionList, toSection: .mission)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvirnment  in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.showsSeparators = false
            config.trailingSwipeActionsConfigurationProvider = self.makeSwipeActions
            let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvirnment)
            layoutSection.interGroupSpacing = 18
            return layoutSection
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
         
         let swipeConfiguration = UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
         
         swipeConfiguration.performsFirstActionWithFullSwipe = false
         return swipeConfiguration
     }
}
