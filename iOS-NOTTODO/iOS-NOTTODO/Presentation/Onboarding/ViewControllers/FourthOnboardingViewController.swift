//
//  FourOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import SnapKit
import Then

class FourthOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case main
    }
    private let onboardingModel: [FourthOnboardingModel] = FourthOnboardingModel.items
    private var dataSource: UICollectionViewDiffableDataSource<Section, FourthOnboardingModel>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let nextButton = UIButton(configuration: .plain())
    private let gradientView = GradientView(color: .clear, color1: .ntdBlack!)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
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
            $0.configuration?.image = .icRightArrow
            $0.configuration?.title = I18N.fourthButton
            $0.configuration?.imagePadding = 2
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
            $0.configuration?.attributedTitle?.font = .Pretendard(.medium, size: 16)
            $0.configuration?.attributedTitle?.foregroundColor = .white
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
            $0.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        }

    }
    
    private func setLayout() {
        view.addSubviews(collectionView, gradientView, nextButton)
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).inset(34)
            $0.size.equalTo(CGSize(width: 95, height: 24))
            $0.bottom.equalTo(safeArea)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27)
            $0.bottom.equalTo(nextButton.snp.top).inset(80)
        }
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top)
            $0.top.equalTo(safeArea).offset(getDeviceHeight()*0.5)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
extension FourthOnboardingViewController {
    @objc
    private func ButtonTapped() {
        print("tapped")
        let nextViewController = FifthOnboardingViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
