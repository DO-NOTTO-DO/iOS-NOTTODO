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
    private let info4: [MyInfoModel4] = MyInfoModel4.item

    enum Sections: Int, Hashable {
        case one, two, three, four
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
        myInfoCollectionView.register(MyProfileCollectionViewCell.self, forCellWithReuseIdentifier: MyProfileCollectionViewCell.identifier)
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileCollectionViewCell.identifier, for: indexPath) as! MyProfileCollectionViewCell
                cell.configure(model: item as! MyInfoModel1 )
                
                return cell
            case .two:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithIcon(model: item as! MyInfoModel2 )
                return cell
            case .three:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithArrow(model: item as! MyInfoModel3)
                return cell
            case .four:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configure(model: item as! MyInfoModel4)
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.one, .two, .three, .four])
        snapShot.appendItems(info1, toSection: .one)
        snapShot.appendItems(info2, toSection: .two)
        snapShot.appendItems(info3, toSection: .three)
        snapShot.appendItems(info4, toSection: .four)
    }
    
    // MARK: - Layout
    private func layout() -> UICollectionViewCompositionalLayout {
   
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                        config.backgroundColor = .clear
                        config.showsSeparators = true
                        config.separatorConfiguration.color = UIColor.gray2!
        config.separatorConfiguration.bottomSeparatorInsets.top = 18
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
  
    }
}
