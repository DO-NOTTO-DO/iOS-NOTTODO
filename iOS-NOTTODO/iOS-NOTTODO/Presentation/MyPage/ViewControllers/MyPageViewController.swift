//
//  MyPageViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import UIKit
import Combine

import Then
import SnapKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<MyPageModel.Section, MyPageRowData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MyPageModel.Section, MyPageRowData>
    
    enum Sections: Int, CaseIterable {
        case profile, support, info, version
    }
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let profilCellTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var dataSource: DataSource?
    private let viewModel: any MyPageViewModel
    
    // MARK: - UI Components
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - init
    
    init(viewModel: some MyPageViewModel) {
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
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.MyInfo.viewMyInfo)
        setUI()
        setLayout()
        setupDataSource()
        setBindings()
    }
}

// MARK: - Methods

extension MyPageViewController {
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        collectionView.do {
            $0.collectionViewLayout = layout()
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
        }
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(22)
            $0.directionalVerticalEdges.equalTo(safeArea)
        }
    }
    
    private func setupDataSource() {
        
        let profileCellRegistration = CellRegistration<MyProfileCollectionViewCell, MyPageRowData> {cell, _, item in
            cell.configure(model: item)
        }
        
        let infoCellRegistration = CellRegistration<InfoCollectionViewCell, MyPageRowData> {cell, indexPath, item in
            
            guard let section = Sections(rawValue: indexPath.section) else { return }
            
            switch section {
            case .support:
                cell.configureWithIcon(with: item)
            case .info:
                cell.configure(with: item, isHidden: false)
            default:
                cell.configure(with: item, isHidden: true)
            }
        }
        
        let headerRegistration = HeaderRegistration<MyPageHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { _, _, _  in }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let section = Sections(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .profile:
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            case  .support, .info, .version:
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func applySnapshot(data: MyPageModel) {
        var snapshot = Snapshot()
        
        data.sections.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows, toSection: section)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env  in
            
            guard let section = Sections(rawValue: sectionIndex) else { return nil }
            switch section {
            case .profile:
                return CompositionalLayout.setUpSection(layoutEnvironment: env,
                                                        mode: .supplementary,
                                                        topContentInset: 24)
            case .support, .info:
                return CompositionalLayout.setUpSection(layoutEnvironment: env,
                                                        topContentInset: 18)
            case .version:
                return CompositionalLayout.setUpSection(layoutEnvironment: env,
                                                        topContentInset: 18,
                                                        bottomContentInset: 60)
            }
        }
        return layout
    }
    
    func setBindings() {
        
        let input = MyPageViewModelInput(viewWillAppearSubject: viewWillAppearSubject, profileCellTapped: profilCellTapped)
        let output = viewModel.transform(input: input)
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.applySnapshot(data: $0)
            }
            .store(in: &cancelBag)
    }
}

// MARK: - CollectionViewDelegate

extension MyPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.profileSectionSelection()
        case 1:
            self.infoSectionSelection(for: indexPath,
                                       events: [.clickGuide, .clickFaq],
                                       urls: [.guid, .faq])
        case 2:
            self.infoSectionSelection(for: indexPath,
                                       events: [.clickNotice, .clickSuggestion, .clickQuestion, .clickTerms],
                                       urls: [.notice, .suggestoin, .question, .service])
        default:
            return
        }
    }
    
    private func profileSectionSelection() {
        sendAnalyticsEvent(.clickMyInfo) {
            profilCellTapped.send(())
        }
    }
    
    private func infoSectionSelection(for indexPath: IndexPath,
                                      events: [AnalyticsEvent.MyInfo],
                                      urls: [MyInfoURL]) {
        guard let item = urls.indices.contains(indexPath.item) ? urls[indexPath.item] : nil,
              let event = events.indices.contains(indexPath.item) ? events[indexPath.item] : nil else { return }
        
        sendAnalyticsEvent(event) {
            Utils.myInfoUrl(vc: self, url: item.url)
        }
    }
    
    private func sendAnalyticsEvent(_ event: AnalyticsEvent.MyInfo, action: () -> Void) {
        AmplitudeAnalyticsService.shared.send(event: event)
        action()
    }
}
