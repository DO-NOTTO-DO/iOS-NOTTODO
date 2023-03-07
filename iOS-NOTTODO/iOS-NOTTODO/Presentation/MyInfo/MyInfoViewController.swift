//
//  MyInfoViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import Then
import SnapKit

final class MyInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let info1: [MyInfoModel1] = MyInfoModel1.item
    private let info2: [MyInfoModel2] = MyInfoModel2.items
    private let info3: [MyInfoModel3] = MyInfoModel3.items

    enum Sections: Int, Hashable {
        case one, two, three
    }
    var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private lazy var myInfoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
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

extension MyInfoViewController {
    
    private func register() {
        myInfoCollectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.identifier)
        myInfoCollectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        myInfoCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setLayout() {
        view.addSubview(myInfoCollectionView)
        
        myInfoCollectionView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: myInfoCollectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .one:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.identifier, for: indexPath) as! MyInfoCollectionViewCell
                cell.configure(model: item as! MyInfoModel1 )
                
                return cell
            case .two:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithIcon(model: item as! MyInfoModel2 )
                return cell
            case .three:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configure(model: item as! MyInfoModel3)
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        
        snapShot.appendSections([.one,.two,.three])
        snapShot.appendItems(info1, toSection: .one)
        snapShot.appendItems(info2, toSection: .two)
        snapShot.appendItems(info3, toSection: .three)
    }
    
    // MARK: - Layout
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvirnment  in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
            case .one, .two, .three:
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.backgroundColor = .clear
                config.showsSeparators = true
                
                let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvirnment)
                layoutSection.orthogonalScrollingBehavior = .none
                layoutSection.interGroupSpacing = 18
                layoutSection.contentInsets = .zero
                
                return layoutSection
            }
        }
        return layout
    }
}
