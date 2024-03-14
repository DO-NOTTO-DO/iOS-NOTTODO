//
//  FourOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import Combine
import SnapKit
import Then

final class FourthOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case main
    }
    private let onboardingModel: [FourthOnboardingModel] = FourthOnboardingModel.items
    private var dataSource: UICollectionViewDiffableDataSource<Section, FourthOnboardingModel>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    private let viewModel: any FourthOnboardingViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private let buttonDidTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let nextButton = UIButton(configuration: .plain())
    private let gradientView = GradientView(color: .clear, color1: .ntdBlack!)
    
    // MARK: - init
    
    init(viewModel: some FourthOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding4)
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
        setBindings()
    }
}

// MARK: - Methods

extension FourthOnboardingViewController {
    private func register() {
        collectionView.register(SubOnboardingCollectionViewCell.self, forCellWithReuseIdentifier: SubOnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.isScrollEnabled = false
        }
        
        nextButton.do {
            $0.configuration?.image = .splashBack
            $0.configuration?.title = I18N.fourthButton
            $0.configuration?.imagePadding = 13
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
            $0.configuration?.attributedTitle?.font = .Pretendard(.medium, size: 16)
            $0.configuration?.baseForegroundColor = .white
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, gradientView, nextButton)
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(34)
            $0.size.equalTo(CGSize(width: 95, height: 24))
            $0.bottom.equalTo(safeArea).inset(12)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top)
            $0.top.equalTo(safeArea).offset(Numbers.height*0.5)
            $0.directionalHorizontalEdges.equalTo(safeArea)
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FourthOnboardingModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubOnboardingCollectionViewCell.identifier, for: indexPath) as? SubOnboardingCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(model: item)
            return cell
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, FourthOnboardingModel>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.main])
        snapShot.appendItems(onboardingModel, toSection: .main)
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier, for: indexPath) as? OnboardingHeaderView else { return UICollectionReusableView() }
            header.configure(isControl: true, title: I18N.fourthOnboarding, subTitle: I18N.onboardingEmpty)
            header.flagImage.isHidden = true
            return header
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 35, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setBindings() {
        let input = FourthOnboardingViewModelInput(
            buttonDidTapped: buttonDidTapped
        )
        _ = viewModel.transform(input: input)
    }
}
extension FourthOnboardingViewController {
    @objc
    private func buttonTapped() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext4)
        
        self.buttonDidTapped.send()
    }
}
