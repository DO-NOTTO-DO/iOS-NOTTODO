//
//  CollectionViewLeftAlignLayout.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/04/02.
//

import UIKit

final class CollectionViewLeftAlignLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 5
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        minimumLineSpacing = 8
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
