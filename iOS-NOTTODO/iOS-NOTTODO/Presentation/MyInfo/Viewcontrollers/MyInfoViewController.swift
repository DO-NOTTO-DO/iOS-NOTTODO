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
    
    private let infoOne: [InfoModelOne] = InfoModelOne.item
    private let infoTwo: [InfoModelTwo] = InfoModelTwo.items
    private let infoThree: [InfoModelThree] = InfoModelThree.items
    private let infoFour: [InfoModelFour] = InfoModelFour.item
    
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
        myInfoCollectionView.register(MyInfoHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoHeaderReusableView.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        myInfoCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setLayout() {
        view.addSubview(myInfoCollectionView)
        
        myInfoCollectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(22)
            $0.directionalVerticalEdges.equalTo(safeArea)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: myInfoCollectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .one:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProfileCollectionViewCell.identifier, for: indexPath) as! MyProfileCollectionViewCell
                cell.configure(model: item as! InfoModelOne )
                return cell
            case .two:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithIcon(model: item as! InfoModelTwo )
                return cell
            case .three:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configureWithArrow(model: item as! InfoModelThree)
                return cell
            case .four:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
                cell.configure(model: item as! InfoModelFour)
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
        snapShot.appendItems(infoOne, toSection: .one)
        snapShot.appendItems(infoTwo, toSection: .two)
        snapShot.appendItems(infoThree, toSection: .three)
        snapShot.appendItems(infoFour, toSection: .four)
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoHeaderReusableView.identifier, for: indexPath) as? MyInfoHeaderReusableView else { return UICollectionReusableView() }
            return header
        }
    }
    
    // MARK: - Layout
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env  in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
            case .one:
                return CompositionalLayout.setUpSection(layoutEnvironment: env, mode: .supplementary, 24, 0)
            case .two, .three:
                return CompositionalLayout.setUpSection(layoutEnvironment: env, mode: .none, 18, 0)
            case .four:
                return CompositionalLayout.setUpSection(layoutEnvironment: env, mode: .none, 18, 60)
            }
        }
        return layout
    }
}
