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
        case mission
    }
    typealias Item = AnyHashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var detailModel: MissionDetailModel?
    
    // MARK: - UI Components
    
    private let deleteButton = UIButton(configuration: .filled())
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let subView = UIView()
    private let completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setUI()
        setLayout()
        setupDataSource()
        reloadData()
    }
}

// MARK: - Methods

extension MissionDetailViewController {
    private func register() {
        collectionView.register(MissionDetailCollectionViewCell.self, forCellWithReuseIdentifier: MissionDetailCollectionViewCell.identifier)
        collectionView.register(DetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderReusableView.identifier)
        collectionView.register(DetailFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DetailFooterReusableView.identifier)
    }
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        deleteButton.do {
            $0.configuration?.title = I18N.detailDelete
            $0.configuration?.cornerStyle = .capsule
            $0.configuration?.attributedTitle?.font = .Pretendard(.semiBold, size: 16)
            $0.configuration?.baseBackgroundColor = .black
            $0.configuration?.baseForegroundColor = .white
            $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        }
        collectionView.do {
            $0.backgroundColor = .white
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 10
            $0.bounces = false
            $0.isScrollEnabled = false
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, deleteButton)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(85)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(50)
            $0.bottom.equalTo(safeArea).inset(10)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionDetailCollectionViewCell.identifier, for: indexPath) as? MissionDetailCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(model: item as! MissionDetailModel)
            return cell
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.mission])
        snapShot.appendItems([detailModel], toSection: .mission)
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderReusableView.identifier, for: indexPath) as? DetailHeaderReusableView else {return UICollectionReusableView()}
                header.cancelClosure = {
                    self.view.alpha = 0
                    self.dismiss(animated: true)
                }
                header.editClosure = {
                    print("edit")
                }
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DetailFooterReusableView.identifier, for: indexPath) as? DetailFooterReusableView else { return UICollectionReusableView() }
                footer.footerClosure = {
                    Utils.modal(self, DetailCalendarViewController(), .overFullScreen)
                    print("tapped")
                }
                return footer
            }
        }
    }
    private func layout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.headerMode = .supplementary
        config.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension MissionDetailViewController {
    @objc
    func deleteBtnTapped() {
        print("Deletetapped")
    }
    @objc
    func completeBtnTapped(sender: UIButton) {
        print("완료")
    }
}
