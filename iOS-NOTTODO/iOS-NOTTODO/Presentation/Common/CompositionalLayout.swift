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
}
