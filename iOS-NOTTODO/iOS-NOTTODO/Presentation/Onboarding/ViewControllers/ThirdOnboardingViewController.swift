//
//  ThirdOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import SnapKit
import Then

final class ThirdOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case main
    }
    
    private let onboardingModel: [ThirdOnboardingModel] = ThirdOnboardingModel.titles
    private var dataSource: UICollectionViewDiffableDataSource<Section, ThirdOnboardingModel>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private var selectList: [String] = []
    private weak var coordinator: AuthCoordinator?
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let nextButton = UIButton()
    private var isTapped: Bool = false
    
    // MARK: - init
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding3)
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
    }
}

// MARK: - Methods

extension ThirdOnboardingViewController {
    private func register() {
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier)
    }
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
            $0.delegate = self
        }
        nextButton.do {
            $0.backgroundColor = isTapped ? .white : .gray2
            $0.isUserInteractionEnabled = isTapped
            $0.makeCornerRound(radius: 25)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.setTitleColor(isTapped ? .black :.gray4, for: .normal)
            $0.setTitle(I18N.thirdButton, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    private func updateButton(isTapped: Bool) {
        nextButton.do {
            $0.backgroundColor = isTapped ? .white : .gray2
            $0.isUserInteractionEnabled = isTapped
            $0.setTitleColor(isTapped ? .black :.gray4, for: .normal)
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, nextButton)
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.bottom.equalTo(safeArea).inset(10)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(50)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ThirdOnboardingModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
            cell.thirdConfigure(model: item)
            return cell
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ThirdOnboardingModel>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.main])
        snapShot.appendItems(onboardingModel, toSection: .main)
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier, for: indexPath) as? OnboardingHeaderView else { return UICollectionReusableView() }
            header.configure(isControl: false, title: I18N.thirdOnboarding, subTitle: I18N.subThirdbOnboarding)
            return header
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55)), subitem: item, count: 2)
        group.interItemSpacing = .fixed(18)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 80, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(210))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ThirdOnboardingViewController {
    @objc
    private func buttonTapped() {
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext3(select: self.selectList))
        self.coordinator?.showFourthOnboardingViewController()
    }
}

extension ThirdOnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let select = collectionView.indexPathsForSelectedItems {
            if select.count > 0 {
                selectList.append(ThirdOnboardingModel.titles[indexPath.row].title)
                self.isTapped = true
                updateButton(isTapped: self.isTapped)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let deSelect = collectionView.indexPathsForSelectedItems {
            if deSelect.count == 0 {
                if let index = selectList.firstIndex(of: ThirdOnboardingModel.titles[indexPath.row].title) {
                    selectList.remove(at: index)
                }
                self.isTapped = false
                updateButton(isTapped: self.isTapped)
                
            }
        }
    }
}
