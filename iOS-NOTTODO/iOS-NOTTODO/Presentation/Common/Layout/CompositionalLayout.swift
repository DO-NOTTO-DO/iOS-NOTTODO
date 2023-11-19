//
//  CompositionalLayout.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/01.
//

import UIKit

final class CompositionalLayout {
    
    class func vertical(itemWidth: NSCollectionLayoutDimension = .fractionalWidth(1),
                         itemHeight: NSCollectionLayoutDimension = .fractionalHeight(1),
                         groupWidth: NSCollectionLayoutDimension = .fractionalWidth(1),
                         groupHeight: NSCollectionLayoutDimension = .fractionalHeight(1),
                         count: Int,
                         edge: NSDirectionalEdgeInsets = .zero) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: groupWidth, heightDimension: groupHeight), subitem: item, count: count)
        return createSection(group, edge)
    }
    
    class func createSection(_ group: NSCollectionLayoutGroup, _ edge: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = edge
        return section
    }
    
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
