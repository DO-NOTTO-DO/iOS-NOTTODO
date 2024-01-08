//
//  FifthOnboardingViewController.swift.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/23.
//

import UIKit

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
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let nextButton = UIButton(configuration: .plain())
    private let arrowImage = UIImageView()
    private let gradientView = GradientView(color: .clear, color1: .ntdBlack!)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Onboarding.viewOnboarding5)
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
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
            $0.configuration?.image = .kakaoAppleIcon
            $0.configuration?.title = I18N.fifthButton
            $0.configuration?.imagePadding = 7
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.leading
            $0.configuration?.attributedTitle?.font = .Pretendard(.medium, size: 16)
            $0.configuration?.baseForegroundColor = .white
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 10)
            $0.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        }
        arrowImage.do {
            $0.image = .splashBack
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, gradientView, nextButton)
        nextButton.addSubview(arrowImage)
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(34)
            $0.size.equalTo(CGSize(width: 205, height: 24))
            $0.bottom.equalTo(safeArea).inset(12)
        }
        arrowImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 16))
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-90)
            $0.top.equalTo(safeArea).offset(getDeviceHeight()*0.5)
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
                return self.MainSection()
            default:
                return self.SubSection()
            }
        })
        return layout
    }
    
    private func MainSection() -> NSCollectionLayoutSection {
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
    
    private func SubSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}

extension FifthOnboardingViewController {
    @objc
    private func ButtonTapped() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingNext5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.01) {
                SceneDelegate.shared?.changeRootViewControllerTo(AuthViewController())
            }
        }
    }
}
