//
//  CollectionViewDiffableDataSource.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/02/27.
//

import UIKit

class CollectionViewDiffableDataSource<S, T>: UICollectionViewDiffableDataSource<S, T> where S: Hashable, T: Hashable {
    
    private var collectionView: UICollectionView?
    private var emptyView: UIView?
    
    convenience init(collectionView: UICollectionView,
                     cellProvider: @escaping UICollectionViewDiffableDataSource<S, T>.CellProvider,
                     emptyView: UIView? = nil) {
        self.init(collectionView: collectionView, cellProvider: cellProvider)
        self.collectionView = collectionView
        self.emptyView = emptyView
    }
    
    override func apply(_ snapshot: NSDiffableDataSourceSnapshot<S, T>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        super.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        
        guard let emptyView = emptyView else { return }
        if snapshot.itemIdentifiers.isEmpty {
            collectionView?.addSubview(emptyView)
            emptyView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            emptyView.removeFromSuperview()
        }
    }
}
