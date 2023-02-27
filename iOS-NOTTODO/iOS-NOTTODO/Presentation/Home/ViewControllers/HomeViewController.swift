//
//  HomeViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let missionList: [MissionListModel] = MissionListModel.items
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    enum Section: Int, Hashable {
        case mission
    }
 //   var dataSource: UICollectionViewDiffableDataSource<Section, MissionListModel>! = nil
    var dataSource: CollectionViewDiffableDataSource<Section, MissionListModel>! = nil
    // MARK: - UI Components
    
    private lazy var missionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private lazy var emptyView: EmptyView? = nil
 //   private let emptyView:
    
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
    }
    
    private func setUI() {
        view.backgroundColor = .bg
        
        missionCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setLayout() {
        view.addSubview(missionCollectionView)
        
        missionCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(162)
            $0.trailing.equalTo(safeArea).inset(18)
            $0.leading.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, MissionListModel>(collectionView: missionCollectionView, cellProvider: { collectionView, indexPath, item in
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCollectionViewCell.identifier, for: indexPath) as? MissionListCollectionViewCell else { return UICollectionViewCell() }
//            cell.configure(model: item)
//            cell.isTappedClosure = { result in
//                if result {
//                    cell.isTapped.toggle()
//                    cell.setUI()
//                }
//            }
//            return cell
//        })
        dataSource = CollectionViewDiffableDataSource<Section, MissionListModel>(collectionView: missionCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionListCollectionViewCell.identifier, for: indexPath) as? MissionListCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(model: item)
            cell.isTappedClosure = { result in
                if result {
                    cell.isTapped.toggle()
                    cell.setUI()
                }
            }
            return cell
        }, emptyView: self.emptyView)
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MissionListModel>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.mission])
        snapShot.appendItems(missionList, toSection: .mission)
    }
    
    // MARK: - Layout
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvirnment  in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.showsSeparators = false
            config.trailingSwipeActionsConfigurationProvider = self.makeSwipeActions
        
            let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvirnment)
            layoutSection.orthogonalScrollingBehavior = .none
            layoutSection.interGroupSpacing = 18
            layoutSection.contentInsets = .zero
            
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
                
//        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: view.frame.width, height: view.frame.height)).image { _ in
//                UIImage.checkboxFill.draw(in: CGRect(x: 40, y: 40 , width:view.frame.width / 3, height: view.frame.width / 3))
//            }
    
        deleteAction.image = .checkboxFill
        modifyAction.image = .checkboxFill

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [modifyAction, deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}
