//
//  CompositionalLayout.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/01.
//

import UIKit

struct CompositionalLayout {
    
    static func vertical(itemWidth: NSCollectionLayoutDimension = .fractionalWidth(1),
                         itemHeight: NSCollectionLayoutDimension = .fractionalHeight(1),
                         groupWidth: NSCollectionLayoutDimension = .fractionalWidth(1),
                         groupHeight: NSCollectionLayoutDimension = .fractionalHeight(1),
                         count: Int,
                         edge: NSDirectionalEdgeInsets = .zero) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: groupWidth, heightDimension: groupHeight), subitem: item, count: count)
        return createSection(group, edge)
    }
    
    static func createSection(_ group: NSCollectionLayoutGroup, _ edge: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = edge
        return section
    }
    
    static func setUpSection(layoutEnvironment: NSCollectionLayoutEnvironment,
                             mode: UICollectionLayoutListConfiguration.HeaderMode = .none,
                             topContentInset: CGFloat = 0,
                             bottomContentInset: CGFloat = 0)
    -> NSCollectionLayoutSection {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfig.headerMode = mode
        listConfig.showsSeparators = true
        listConfig.separatorConfiguration.color = UIColor.gray2!
        listConfig.backgroundColor = .clear
        listConfig.headerTopPadding = 22
        
        let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: topContentInset, leading: 0, bottom: bottomContentInset, trailing: 0)
        
        if listConfig.headerMode == .supplementary {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(22))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        return section
    }
}
