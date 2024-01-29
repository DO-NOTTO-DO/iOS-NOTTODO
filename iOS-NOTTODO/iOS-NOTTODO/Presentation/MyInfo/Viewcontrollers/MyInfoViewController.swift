//
//  MyInfoViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import Then
import SnapKit

final class MyInfoViewController: UIViewController {
    
    // MARK: - Properties

    typealias CellRegistration = UICollectionView.CellRegistration
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<Sections, InfoModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, InfoModel>
    
    enum Sections: Int, CaseIterable {
        case profile, support, info, version
    }
    
    private var dataSource: DataSource?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private let myInfoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.MyInfo.viewMyInfo)
        setUI()
        setLayout()
        setupDataSource()
        setSnapShot()
    }
}

// MARK: - Methods

extension MyInfoViewController {
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        myInfoCollectionView.do {
            $0.collectionViewLayout = layout()
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
        }
    }
    
    private func setLayout() {
        view.addSubview(myInfoCollectionView)
        
        myInfoCollectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(22)
            $0.directionalVerticalEdges.equalTo(safeArea)
        }
    }
    
    private func setupDataSource() {
        
        let profileCellRegistration = CellRegistration<MyProfileCollectionViewCell, InfoModel> {cell, _, item in
            cell.configure(model: item)
        }
        
        let infoCellRegistration = CellRegistration<InfoCollectionViewCell, InfoModel> {cell, indexPath, item in
            
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
        
        let headerRegistration = HeaderRegistration<MyInfoHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { _, _, _  in }
        
        dataSource = DataSource(collectionView: myInfoCollectionView, cellProvider: { collectionView, indexPath, item in
            
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
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
    }
    
    private func setSnapShot() {
        
        var snapShot = SnapShot()
        
        defer {
            dataSource?.apply(snapShot, animatingDifferences: false)
        }
        
        snapShot.appendSections(Sections.allCases)
        snapShot.appendItems(InfoModel.profile, toSection: .profile)
        snapShot.appendItems(InfoModel.support, toSection: .support)
        snapShot.appendItems(InfoModel.info, toSection: .info)
        snapShot.appendItems(InfoModel.version(), toSection: .version)
        
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
}

// MARK: - CollectionViewDelegate

extension MyInfoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            profileSectionSelection()
        case 1:
            infoSectionSelection(for: indexPath,
                                 events: [.clickGuide, .clickFaq],
                                 urls: [.guid, .faq])
        case 2:
            infoSectionSelection(for: indexPath,
                                 events: [.clickNotice, .clickQuestion, .clickTerms],
                                 urls: [.notice, .question, .service])
        default:
            return
        }
    }
    
    private func profileSectionSelection() {
        sendAnalyticsEvent(.clickMyInfo) {
            
            let nextViewController = MyInfoAccountViewController()
            nextViewController.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    private func infoSectionSelection(for indexPath: IndexPath,
                                      events: [AnalyticsEvent.MyInfo],
                                      urls: [MyInfoURL]) {
        guard let item = urls.indices.contains(indexPath.item) ? urls[indexPath.item] : nil,
              let event = events.indices.contains(indexPath.item) ? events[indexPath.item] : nil else {
            return
        }
        
        sendAnalyticsEvent(event) {
            Utils.myInfoUrl(vc: self, url: item.url)
        }
    }
    
    private func sendAnalyticsEvent(_ event: AnalyticsEvent.MyInfo, action: () -> Void) {
        AmplitudeAnalyticsService.shared.send(event: event)
        action()
    }
}
