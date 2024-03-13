//
//  DetailAchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/14.
//

import UIKit
import Combine

import Then
import SnapKit

final class DetailAchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
    typealias Item = AchieveDetailData
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>

    enum Section: Int, Hashable {
        case main
    }

    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let dismissSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()

    private var dataSource: DataSource?
    private var viewModel: any DetailAchievementViewModel
    
    // MARK: - UI Components
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - init
    
    init(viewModel: some DetailAchievementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearSubject.send(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDataSource()
        setSnapShot()
        setBindings()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !collectionView.frame.contains(location) {
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Achieve.closeDailyMissionModal)
            dismissSubject.send(())
        }
    }
}

// MARK: - Methods

extension DetailAchievementViewController {
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        collectionView.do {
            $0.collectionViewLayout = layout()
            $0.makeCornerRound(radius: 15)
            $0.backgroundColor = .white
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(Numbers.width*1.1)
        }
    }
    
    private func setDataSource() {
        
        let cellRegistration = CellRegistration<DetailAchievementCollectionViewCell, Item> {cell, index, item in
            print("index: \(index.item)")
            cell.configure(model: item)
        }
        
        let headerRegistration = HeaderRegistration<DetailAchieveHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, _, indexPath in
            guard let item = self?.dataSource?.itemIdentifier(for: indexPath) else { return }
            headerView.configure(text: item.formatDateString())
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
            
        }
    }
    
    private func setBindings() {
        let input = DetailAchievementViewModelInput(viewWillAppearSubject: viewWillAppearSubject, dismissSubject: dismissSubject)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                self?.setSnapShot(with: item)
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Achieve.appearDailyMissionModal(total: item.count))
            }
            .store(in: &cancelBag)
    }
    
    private func setSnapShot(with items: [AchieveDetailData] = []) {
        var snapShot = SnapShot()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        
        dataSource?.applySnapshotUsingReloadData(snapShot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.backgroundColor = .clear
        config.separatorConfiguration.color = .gray5!
        config.separatorConfiguration.topSeparatorVisibility = .hidden
        config.separatorConfiguration.bottomSeparatorInsets = .init(top: 0,
                                                                    leading: 20,
                                                                    bottom: 0,
                                                                    trailing: 20)
        config.itemSeparatorHandler = { [weak self] indexPath, config in
            var config = config
            guard let itemCount = self?.dataSource?.snapshot().itemIdentifiers(inSection: .main).count else { return config }
            let isLastItem = indexPath.item == itemCount - 1
            config.bottomSeparatorVisibility = isLastItem ? .hidden : .visible
            return config
        }
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
