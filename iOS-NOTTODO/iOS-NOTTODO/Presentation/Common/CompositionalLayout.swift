//
//  CompositionalLayout.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/01.
//

import UIKit

final class CompositionalLayout {

    class func _vertical(_ itemWidth: NSCollectionLayoutDimension, _ itemHeight: NSCollectionLayoutDimension, _ groupWidth: NSCollectionLayoutDimension, _ groupHeight: NSCollectionLayoutDimension, count: Int, edge: NSDirectionalEdgeInsets?, footer: Bool) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: itemWidth, heightDimension: itemHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: groupWidth, heightDimension: groupHeight), subitem: item, count: count )
        return section(group, edge ?? NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), footer)
    }
    
    class func section(_ group: NSCollectionLayoutGroup, _ edge: NSDirectionalEdgeInsets, _ footer: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = edge
        
        if footer {
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,elementKind: UICollectionView.elementKindSectionFooter,alignment: .bottom)
            section.boundarySupplementaryItems = [footer]
        }
        return section
    }
}
