//
//  CompositionalLayout.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/01.
//

import UIKit

final class CompositionalLayout {
    
    class func _vertical(_ itemWidth: NSCollectionLayoutDimension, _ itemHeight: NSCollectionLayoutDimension, _ groupWidth: NSCollectionLayoutDimension, _ groupHeight: NSCollectionLayoutDimension, count: Int, edge: NSDirectionalEdgeInsets?) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: groupWidth, heightDimension: groupHeight), subitem: item, count: count )
        return section(group, edge ?? NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    class func section(_ group: NSCollectionLayoutGroup, _ edge: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
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
