//
//  FiveOnboardingViewController.swift.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/23.
//

import UIKit

class FiveOnboardingViewController: UIViewController {
    
    enum Sections {
        case main, sub
    }
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    var onboardingModel: FourOnboardingModel = FourOnboardingModel.items[4]
    var fiveOnboardingModel: [FiveOnboardingModel] = FiveOnboardingModel.titles
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let nextButton = UIButton(configuration: .plain())
    private let arrowImage = UIImageView()
    private var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
    }
}
extension FiveOnboardingViewController {
    private func register() {
        collectionView.register(SubOnboardingCollectionViewCell.self, forCellWithReuseIdentifier: SubOnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier)
        collectionView.register(OnboardingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: OnboardingFooterView.identifier)
    }
    private func setUI() {
        collectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.isScrollEnabled = false
        }
        nextButton.do {
            $0.configuration?.image = .kakaoAppleIcon
            $0.configuration?.title = "로그인하고 시작하기"
            $0.configuration?.imagePadding = 7
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.leading
            $0.configuration?.attributedTitle?.font = .Pretendard(.medium, size: 16)
            $0.configuration?.attributedTitle?.foregroundColor = .white
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
            $0.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        }
        arrowImage.do {
            $0.image = .icRightArrow
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, nextButton)
        nextButton.addSubview(arrowImage)
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(34)
            $0.size.equalTo(CGSize(width: 205, height: 24))
            $0.bottom.equalTo(safeArea)
        }
        arrowImage.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.trailing.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27)
            $0.bottom.equalTo(nextButton.snp.top).inset(80)
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubOnboardingCollectionViewCell.identifier, for: indexPath) as! SubOnboardingCollectionViewCell
                cell.configure(model: item as! FourOnboardingModel)
                return cell
            case .sub:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
                cell.fiveConfigure(model: item as! FiveOnboardingModel)
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
                header.configure(isControl: true, title: "낫투두를 실천할 방법과\n환경을 정해요", subTitle: "달성률을 높이기 위해선 필수!")
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210))
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
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

extension FiveOnboardingViewController {
    @objc
    private func ButtonTapped() {
        print("tapped")
    }
}
