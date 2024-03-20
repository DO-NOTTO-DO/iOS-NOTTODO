//
//  FifthOnboardingViewController.swift.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/23.
//

import UIKit

import Combine
import SnapKit
import Then

final class FifthOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Sections {
        case main, sub
    }
    
    var onboardingModel: FourthOnboardingModel = FourthOnboardingModel.items[4]
    var fiveOnboardingModel: [FifthOnboardingModel] = FifthOnboardingModel.titles
    private var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    private let viewModel: any FifthOnboardingViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private let loginButtonDidTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let nextButton = UIButton(configuration: .plain())
    private let arrowImage = UIImageView()
    private let gradientView = GradientView(color: .clear, color1: .ntdBlack!)
    
    // MARK: - init
    init(viewModel: some FifthOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding5)
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
        setBindings()
    }
}

// MARK: - Methods

extension FifthOnboardingViewController {
    private func register() {
        collectionView.register(SubOnboardingCollectionViewCell.self, forCellWithReuseIdentifier: SubOnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier)
        collectionView.register(OnboardingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: OnboardingFooterView.identifier)
    }
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.isScrollEnabled = false
        }
        
        nextButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.image = .kakaoAppleIcon
            configuration.title = I18N.fifthButton
            configuration.imagePadding = 7
            configuration.imagePlacement = NSDirectionalRectEdge.leading
            configuration.attributedTitle?.font = .Pretendard(.medium, size: 16)
            configuration.baseForegroundColor = .white
            configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 10)
            $0.configuration = configuration
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        arrowImage.do {
            $0.image = .splashBack
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, gradientView, nextButton)
        nextButton.addSubview(arrowImage)
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(34.adjusted)
            $0.size.equalTo(CGSize(width: 205.adjusted, height: 24.adjusted))
            $0.bottom.equalTo(safeArea).inset(12.adjusted)
        }
        arrowImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8.adjusted, height: 16.adjusted))
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27.adjusted)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-90.adjusted)
            $0.top.equalTo(safeArea).offset(Numbers.height*0.5)
            $0.directionalHorizontalEdges.equalTo(safeArea)
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubOnboardingCollectionViewCell.identifier, for: indexPath) as! SubOnboardingCollectionViewCell
                cell.configure(model: item as! FourthOnboardingModel)
                return cell
            case .sub:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
                cell.fiveConfigure(model: item as! FifthOnboardingModel)
                cell.isUserInteractionEnabled = false
                return cell
            }
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.main, .sub])
        snapShot.appendItems([onboardingModel], toSection: .main)
        snapShot.appendItems(fiveOnboardingModel, toSection: .sub)
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier, for: indexPath) as? OnboardingHeaderView else { return UICollectionReusableView() }
                header.configure(isControl: true, title: I18N.fifthOnboarding, subTitle: I18N.subFifthOnboarding)
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: OnboardingFooterView.identifier, for: indexPath) as? OnboardingFooterView else { return UICollectionReusableView() }
                return footer
            }
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
            case .main:
                return self.mainSection()
            default:
                return self.subSection()
            }
        })
        return layout
    }
    
    private func mainSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210))
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
    
    private func subSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    private func setBindings() {
        let input = FifthOnboardingViewModelInput(
            loginButtonDidTapped: loginButtonDidTapped
        )
        _ = viewModel.transform(input: input)
    }
}

extension FifthOnboardingViewController {
    @objc
    private func buttonTapped() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext5)
        
        self.loginButtonDidTapped.send()
    }
}
