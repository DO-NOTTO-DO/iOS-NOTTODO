//
//  ThirdOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/22.
//

import UIKit

import Then
import SnapKit

class ThirdOnboardingViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private var isTapped: Bool = false
    private let onboardingModel: [ThirdOnboardingModel] = ThirdOnboardingModel.titles
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let nextButton = UIButton()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ThirdOnboardingModel>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        register()
        setLayout()
        setupDataSource()
        reloadData()
    }
}
extension ThirdOnboardingViewController {
    private func register() {
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.register(OnboardingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OnboardingHeaderView.identifier)
    }
    private func setUI() {
        collectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
            $0.delegate = self
        }
        nextButton.do {
            $0.backgroundColor = isTapped ? .white : .gray2
            $0.isUserInteractionEnabled = false
            $0.layer.cornerRadius = 25
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.setTitleColor(isTapped ? .black :.gray4, for: .normal)
            $0.setTitle("사용법이 궁금해요", for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, nextButton)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(27)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.bottom.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(50)
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
            header.configure(isControl: false, title: "하루 중 어느 순간을\n가장 개선하고 싶으세요?", subTitle: "여러개 선택할 수 있어요")
            return header
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55)), subitem: item, count: 2)
        group.interItemSpacing = .fixed(18)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
extension ThirdOnboardingViewController {
    @objc
    private func buttonTapped() {
        let nextViewController = FourOnboardingViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
extension ThirdOnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selctItem = collectionView.indexPathsForSelectedItems {
            if selctItem.count > 0 {
                print("select:\(selctItem.count)")
                self.isTapped = true
                self.nextButton.isUserInteractionEnabled = true
                setUI()
                let nextViewController = FourOnboardingViewController()
                navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
}
