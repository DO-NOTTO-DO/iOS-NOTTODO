//
//  RecommendActionViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

class RecommendActionViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    let nextButton = UIButton()
    private lazy var recommendActionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // test
    
    var recommendActionList: [RecommendActionModel] = [
        RecommendActionModel(title: "배고플 때마다 양치하기", body: "치약 성분은 식욕감을 떨어뜨리는데 도움을 줘요."),
        RecommendActionModel(title: "삶은 게란으로 대신하기", body: "삶은 계란은 멜라토닌 생성을 도와\n숙면을 유도한다는 사실을 알고 계셨나요?"),
        RecommendActionModel(title: "배고플 때마다 양치하기", body: "치약 성분은 식욕감을 떨어뜨리는데 도움을 줘요."),
        RecommendActionModel(title: "배고플 때마다 양치하기", body: "치약 성분은 식욕감을 떨어뜨리는데 도움을 줘요.")
    ]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        register()
        setDelegate()
    }
}

// MARK: - Methods

private extension RecommendActionViewController {
    func setUI() {
        view.backgroundColor = .ntdBlack
        recommendActionCollectionView.backgroundColor = .clear
        
        backButton.do {
            $0.setBackgroundImage(.back, for: .normal)
            // $0.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.recommendNavTitle
        }
        
        nextButton.do {
            $0.setTitle(I18N.next, for: .normal)
            $0.setTitleColor(.gray1, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 17.18) // 수정 필요
            $0.backgroundColor = .white
        }
    }
    
    func setLayout() {
        view.addSubviews(navigationView, recommendActionCollectionView, nextButton)
        navigationView.addSubviews(backButton, navigationTitle)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        recommendActionCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-9)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(76)
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 15
        let itemLayout = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(345), heightDimension: .estimated(70)))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(345), heightDimension: .fractionalHeight(1)), subitem: itemLayout, count: 4)
        groupLayout.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = spacing
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(217)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(53)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        ]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func register() {
        recommendActionCollectionView.register(RecommendActionHeaderView.self,
                                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                               withReuseIdentifier: RecommendActionHeaderView.identifier)
        recommendActionCollectionView.register(RecommendActionCollectionViewCell.self,
                                               forCellWithReuseIdentifier: RecommendActionCollectionViewCell.identifier)
        recommendActionCollectionView.register(RecommendActionFooterView.self,
                                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                               withReuseIdentifier: RecommendActionFooterView.identifier)
        
    }
    
    func setDelegate() {
        recommendActionCollectionView.dataSource = self
    }
}

extension RecommendActionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return recommendActionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendActionCollectionViewCell.identifier, for: indexPath)
                as? RecommendActionCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(model: recommendActionList[indexPath.row])
        return cell
    }
}
