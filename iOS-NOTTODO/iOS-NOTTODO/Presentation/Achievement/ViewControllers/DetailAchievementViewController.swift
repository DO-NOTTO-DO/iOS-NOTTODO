//
//  DetailAchievementViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/14.
//

import UIKit

import Then
import SnapKit

class DetailAchievementViewController: UIViewController {
    
    // MARK: - Properties
    
    var missionList: [MissionDetailResponseDTO] = []
    private var mission: String?
    private var goal: String?
    enum Section: Int, Hashable {
        case main
    }
    typealias Item = MissionListModel
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private let backGroundView = UIView()
    private let dateLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestDetailAPI(missionId: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setUI()
        setLayout()
        setRecognizer()
        setupDataSource()
        reloadData()
    }
}

// MARK: - Methods

extension DetailAchievementViewController {
    private func register() {
        collectionView.register(DetailAchievementCollectionViewCell.self, forCellWithReuseIdentifier: DetailAchievementCollectionViewCell.identifier)
    }
    
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        
        backGroundView.do {
            $0.layer.cornerRadius = 15
            $0.backgroundColor = .white
            $0.isUserInteractionEnabled = false
        }
        dateLabel.do {
            $0.text = "2023년 12월 11일"
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .gray2
            $0.textAlignment = .center
        }
        collectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setLayout() {
        view.addSubview(backGroundView)
        backGroundView.addSubviews(dateLabel, collectionView)
        
        backGroundView.snp.makeConstraints {
            $0.center.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(getDeviceWidth()*1.1)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAchievementCollectionViewCell.identifier, for: indexPath) as? DetailAchievementCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(model: item)
            return cell
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        
        snapShot.appendSections([.main])
        snapShot.appendItems([], toSection: .main)
    }
//    private func updateData(item: [MissionDetailResponseDTO]) {
//            var snapshot = dataSource.snapshot()
//            snapshot.appendItems(item, toSection: .main)
//            dataSource.apply(snapshot)
//        }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .clear
        config.separatorConfiguration.color = .gray5!
        let listLayout = UICollectionViewCompositionalLayout.list(using: config)
        return listLayout
    }
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false)
    }
}
extension DetailAchievementViewController {
    func requestDetailAPI(missionId: Int) {
        AchieveAPI.shared.getMissionDetail(missionId: missionId) { [self] result in
            switch result {
            case let .success(data):
                guard let data = data as? [MissionDetailResponseDTO] else { return }
                self.missionList = data
               // updateData(item: missionList)
            case .requestErr:
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
