//
//  MyInfoAccountViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/18.
//

import UIKit
import Combine

final class MyInfoAccountViewController: UIViewController {
    
    // MARK: - Property
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<Sections, AccountRowData>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, AccountRowData>
    
    enum Sections: Int, CaseIterable {
        case account, logout
    }
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let withdrawalTapped = PassthroughSubject<Void, Never>()
    private let logoutTapped = PassthroughSubject<Void, Never>()
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var dataSource: DataSource?
    private var viewModel: any MyPageAccountViewModel
    
    // MARK: - UI Components
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    private let seperateView = UIView()
    private let withdrawButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: - init
    
    init(viewModel: some MyPageAccountViewModel) {
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
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.viewAccountInfo)
        
        setUI()
        setLayout()
        setupDataSource()
        setBindings()
    }
}

// MARK: - Methods

private extension MyInfoAccountViewController {
    
    func setUI() {
        view.backgroundColor = .ntdBlack
        seperateView.backgroundColor = .gray2
        
        backButton.do {
            $0.setBackgroundImage(.icBack, for: .normal)
            $0.addTarget(self, action: #selector(popBackbutton), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.myInfoAccount
        }
        
        collectionView.do {
            $0.collectionViewLayout = layout()
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self
        }
        
        withdrawButton.do {
            $0.setTitle(I18N.withdraw, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 12)
            $0.setUnderline()
            $0.addTarget(self, action: #selector(presentToWithdraw), for: .touchUpInside)
        }
    }
    
    func setLayout() {
        view.addSubviews(navigationView, seperateView, collectionView, withdrawButton)
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
        
        seperateView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(35)
            $0.horizontalEdges.equalTo(safeArea).inset(22)
            $0.bottom.equalTo(safeArea)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.centerX.equalTo(safeArea)
            $0.bottom.equalTo(safeArea).inset(119)
        }
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<MyInfoAccountCollectionViewCell, AccountRowData> {cell, _, item in
            cell.configure(data: item)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
    }
    
    private func setBindings() {
        let input = MyPageAccountViewModelInput(viewWillAppearSubject: viewWillAppearSubject, withdrawalTapped: withdrawalTapped, logoutTapped: logoutTapped, backButtonTapped: backButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.setSnapShot(userInfo: $0.profileData, logout: $0.logout)
            }
            .store(in: &cancelBag)
    }
    
    private func setSnapShot(userInfo: [AccountRowData], logout: [AccountRowData]) {
        var snapShot = SnapShot()
        
        snapShot.appendSections(Sections.allCases)
        snapShot.appendItems(userInfo, toSection: .account)
        snapShot.appendItems(logout, toSection: .logout)
        
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
    
    private func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, env in
            return CompositionalLayout.setUpSection(layoutEnvironment: env, topContentInset: 18)
        }
    }
    
    @objc
    private func presentToWithdraw() {
        withdrawalTapped.send(())
    }
    
    @objc
    private func popBackbutton() {
        backButtonTapped.send(())
    }
}

extension MyInfoAccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Sections(rawValue: indexPath.section)
        switch section {
        case .logout:
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.appearLogoutModal)
            logoutTapped.send(())
        default: break
        }
    }
}
