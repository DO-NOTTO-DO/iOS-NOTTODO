//
//  MissionDetailViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

class MissionDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    enum Section {
        case main
    }
    typealias Item = AnyHashable
    private var dataSource:  UICollectionViewDiffableDataSource<Section, Item>
    private let detailModel: [MissionDetailModel] = MissionDetailModel.items
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let horizontalStackview = UIStackView()
    private let cancelButton = UIButton()
    private let editButton = UIButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension MissionDetailViewController {
    private func register() {
        collectionView.register(DetailMissionCollectionViewCell.self, forCellWithReuseIdentifier: DetailMissionCollectionViewCell.identifier)
        collectionView.register(DetailActionGoalCollectionViewCell.self, forCellWithReuseIdentifier: DetailActionGoalCollectionViewCell.identifier)
    }
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        containerView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 10
        }
        cancelButton.do {
            $0.backgroundColor = .systemBlue
            $0.setImage(.delete, for: .normal)
        }
        editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
        }
        horizontalStackview.do {
            $0.addArrangedSubviews(cancelButton, editButton)
            $0.axis = .horizontal
        }
    }
    
    private func setLayout() {
        view.addSubview(containerView)
        containerView.addSubview(horizontalStackview)
        
        cancelButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalTo(safeArea).offset(24)
        }
        editButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 35))
            $0.trailing.equalTo(safeArea).inset(17)
        }
        horizontalStackview.snp.makeConstraints {
            $0.directionalVerticalEdges.equalTo(safeArea)
            $0.top.equalToSuperview().offset(20)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalStackview.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch indexPath {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailMissionCollectionViewCell.identifier, for: indexPath) as! DetailMissionCollectionViewCell
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailActionGoalCollectionViewCell.identifier, for: indexPath) as! DetailActionGoalCollectionViewCell
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        
        snapShot.appendSections([.main])
        snapShot.appendItems(detailModel)
    }
}
