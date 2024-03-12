//
//  MissionDetailViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

final class MissionDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias FooterRegistration = UICollectionView.SupplementaryRegistration
    typealias Item = MissionDetailResponseDTO
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource?
    private var detailModel: MissionDetailResponseDTO?
    var userId: Int?
    
    var deleteClosure: (() -> Void)?
    var moveDateClosure: ((String) -> Void)?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    private weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Components
    
    private let headerView = DetailHeaderView()
    private let deleteButton = UIButton(configuration: .filled())
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - init
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let id = self.userId else { return }
        requestDailyMissionAPI(id: id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setupDataSource()
        setSnapShot()
    }
}

// MARK: - Methods

extension MissionDetailViewController {
    
    private func setUI() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = .black.withAlphaComponent(0.6)
            }
        }
        
        headerView.do {
            $0.backgroundColor = .white
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.makeCornerRound(radius: 10)
        }
        
        collectionView.do {
            $0.collectionViewLayout = layout()
            $0.bounces = false
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = .init(top: -30, left: 0, bottom: 88, right: 0)
        }
        
        deleteButton.do {
            
            var config = UIButton.Configuration.filled()
            config.title = I18N.detailDelete
            config.cornerStyle = .capsule
            config.baseBackgroundColor = .black
            config.baseForegroundColor = .white
            config.attributedTitle?.font = .Pretendard(.semiBold, size: 16)
            
            $0.configuration = config
            $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        }
        
        configureHeaderView()
    }
    
    private func setLayout() {
        view.addSubviews(headerView, collectionView, deleteButton)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).inset(58)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(74)
        }
        
        deleteButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(50)
            $0.bottom.equalTo(safeArea).inset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        
        let cellRegistration = CellRegistration<MissionDetailCollectionViewCell, Item> { cell, _, item in
            cell.configure(model: item)
        }
        
        let footerRegistration = FooterRegistration<DetailFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] footerView, _, _ in
            footerView.footerClosure = { [weak self] in
                guard let self = self,
                      let id = self.userId,
                      let data = self.detailModel
                else { return }
                self.coordinator?.showSelectDateViewController(data: data, id: id) { date in
                    self.moveDateClosure?(date)
                }
            }
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration,
                                                                         for: indexPath)
        }
    }
    
    private func configureHeaderView() {
        headerView.cancelClosure = { [weak self] in
            guard let self else { return }
            self.view.alpha = 0
            coordinator?.dismiss()
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.closeDetailMission)
        }
        
        headerView.editClosure = { [weak self] in
            guard let self else { return }
            guard let id = self.userId else { return }
            coordinator?.showModifyViewController(id: id, type: .update)
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickEditMission(section: "detail"))
        }
    }
    
    private func setSnapShot() {
        
        var snapShot = SnapShot()
        
        if let detailModel = self.detailModel {
            snapShot.appendSections([.main])
            snapShot.appendItems([detailModel], toSection: .main)
        }
        
        dataSource?.applySnapshotUsingReloadData(snapShot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.backgroundColor = .white
        config.showsSeparators = false
        config.footerMode = .supplementary
        
        return UICollectionViewCompositionalLayout.list(using: config)
        
    }
}

extension MissionDetailViewController {
    
    @objc
    func deleteBtnTapped() {
        
        guard let data = detailModel else { return }
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.clickDeleteMission(section: "detail",
                                                                                              title: data.title,
                                                                                              situation: data.situation,
                                                                                              goal: data.goal,
                                                                                              action: data.actions.map { $0.name }))
        coordinator?.showDeleteViewController { [weak self] in
            guard let self else { return }
            guard let id = self.userId else { return }
            self.requestDeleteMission(id: id)
        }
    }
}

extension MissionDetailViewController {
    
    func requestDailyMissionAPI(id: Int) {
        MissionAPI.shared.getDetailMission(id: id) { [weak self] response in
            guard let self else { return }
            guard let response = response else { return }
            guard let data = response.data else { return }
            
            self.detailModel = data
            self.setSnapShot()
            
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.appearDetailMission(title: data.title,
                                                                                                   situation: data.situation,
                                                                                                   goal: data.goal,
                                                                                                   action: data.actions.map { $0.name }))
        }
    }
    
    private func requestDeleteMission(id: Int) {
        MissionAPI.shared.deleteMission(id: id) { [weak self] _ in
            guard let self else { return }
            guard let data = self.detailModel else { return }
            if data.id == id {
                self.deleteClosure?()
                self.setSnapShot()
                
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.completeDeleteMission(section: "detail",
                                                                                                         title: data.title,
                                                                                                         situation: data.situation,
                                                                                                         goal: data.goal,
                                                                                                         action: data.actions.map { $0.name }))
                
                coordinator?.dismiss()
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Detail.closeDetailMission)
                
            }
        }
    }
}
