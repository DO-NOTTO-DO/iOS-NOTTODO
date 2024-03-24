//
//  MyInfoAccountViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/18.
//

import UIKit
import Combine

final class MyPageAccountViewController: UIViewController {
    
    // MARK: - Property
    
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
    typealias DataSource = UICollectionViewDiffableDataSource<MyInfoAccountSections, AccountRowData>
    typealias SnapShot = NSDiffableDataSourceSnapshot<MyInfoAccountSections, AccountRowData>
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let withdrawalTapped = PassthroughSubject<Void, Never>()
    private let logoutTapped = PassthroughSubject<Void, Never>()
    private let backButtonTapped = PassthroughSubject<Void, Never>()
    private let switchButtonTapped = PassthroughSubject<Bool, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var dataSource: DataSource?
    private var viewModel: any MyPageAccountViewModel
    
    // MARK: - UI Components
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private let navigationView = NottodoNavigationView()
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
        
        setUI()
        setLayout()
        setupDataSource()
        setBindings()
    }
}

// MARK: - Methods

private extension MyPageAccountViewController {
    
    func setUI() {
        view.backgroundColor = .ntdBlack
        
        navigationView.do {
            $0.setTitle(I18N.myInfoAccount)
            $0.buttonTapped.sink { [weak self] _ in
                guard let self else { return }
                self.backButtonTapped.send(())
            }
            .store(in: &navigationView.cancelBag)
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
        view.addSubviews(navigationView, collectionView, withdrawButton)
        
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea)
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
        
        let cellRegistration = CellRegistration<MyPageAccountCollectionViewCell, AccountRowData> { [weak self] cell, _, item in
            cell.configure(data: item)
            cell.switchTapped
                .receive(on: RunLoop.main)
                .sink { isOn in
                    self?.switchButtonTapped.send(isOn)
                }
                .store(in: &cell.cancelBag)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
    }
    
    private func setBindings() {
        
        let input = MyPageAccountViewModelInput(viewWillAppearSubject: viewWillAppearSubject,
                                                withdrawalTapped: withdrawalTapped,
                                                logoutTapped: logoutTapped,
                                                backButtonTapped: backButtonTapped,
                                                switchButtonTapped: switchButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                self.setSnapShot(userInfo: $0.profileData, logout: $0.logout)
            }
            .store(in: &cancelBag)
        
        output.openNotificationSettings
            .receive(on: RunLoop.main)
            .sink {
                UIApplication.shared.openAppNotificationSettings()
            }
            .store(in: &cancelBag)
    }
    
    private func setSnapShot(userInfo: [AccountRowData], logout: [AccountRowData]) {
        var snapShot = SnapShot()
        
        snapShot.appendSections(MyInfoAccountSections.allCases)
        snapShot.appendItems(userInfo, toSection: .account)
        snapShot.appendItems(logout, toSection: .logout)
        
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    private func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, env in
            return CompositionalLayout.setUpSection(layoutEnvironment: env, topContentInset: 18)
        }
    }
}

extension MyPageAccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == MyInfoAccountSections.logout.rawValue { logoutTapped.send(()) }
    }
}

extension MyPageAccountViewController {
    
    @objc
    private func presentToWithdraw() {
        withdrawalTapped.send(())
    }
}
