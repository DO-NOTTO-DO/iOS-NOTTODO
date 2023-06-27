//
//  MissionDetailViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

final class MissionDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var deleteClosure: (() -> Void)?
    var moveDateClosure: ((_ date: String) -> Void)?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    enum Section {
        case mission
    }
    typealias Item = AnyHashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var detailModel: [MissionDetailResponseDTO] = []
    var userId: Int?
    
    // MARK: - UI Components
    
    private let deleteButton = UIButton(configuration: .filled())
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = self.userId else { return }
        requestDailyMissionAPI(id: id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setUI()
        setLayout()
        setupDataSource()
        reloadData()
    }
}

// MARK: - Methods

extension MissionDetailViewController {
    private func register() {
        collectionView.register(MissionDetailCollectionViewCell.self, forCellWithReuseIdentifier: MissionDetailCollectionViewCell.identifier)
        collectionView.register(DetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderReusableView.identifier)
        collectionView.register(DetailFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DetailFooterReusableView.identifier)
    }
    private func setUI() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = .black.withAlphaComponent(0.6)
            }
        }
        
        deleteButton.do {
            $0.configuration?.title = I18N.detailDelete
            $0.configuration?.cornerStyle = .capsule
            $0.configuration?.attributedTitle?.font = .Pretendard(.semiBold, size: 16)
            $0.configuration?.baseBackgroundColor = .black
            $0.configuration?.baseForegroundColor = .white
            $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        }
        collectionView.do {
            $0.backgroundColor = .white
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 10
            $0.bounces = false
            $0.isScrollEnabled = false
        }
    }
    
    private func setLayout() {
        view.addSubviews(collectionView, deleteButton)
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(getDeviceHeight()*0.88)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(15)
            $0.height.equalTo(50)
            $0.bottom.equalTo(safeArea).inset(10)
        }
    }
    
    // MARK: - Data
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionDetailCollectionViewCell.identifier, for: indexPath) as? MissionDetailCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(model: item as! MissionDetailResponseDTO)
            return cell
        })
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        defer {
            dataSource.apply(snapShot, animatingDifferences: false)
        }
        snapShot.appendSections([.mission])
        snapShot.appendItems(detailModel, toSection: .mission)
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderReusableView.identifier, for: indexPath) as? DetailHeaderReusableView else {return UICollectionReusableView()}
                header.cancelClosure = {
                    self.view.alpha = 0
                    self.dismiss(animated: true)
                }
                header.editClosure = {
                    let updateMissionViewController = AddMissionViewController()
                    guard let rootViewController = self.presentingViewController as? UINavigationController else { return }
                    updateMissionViewController.setMissionId(self.userId ?? 0)
                    updateMissionViewController.setViewType(.update)
                    self.dismiss(animated: true) {
                        rootViewController.pushViewController(updateMissionViewController, animated: true)
                    }
                }
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DetailFooterReusableView.identifier, for: indexPath) as? DetailFooterReusableView else { return UICollectionReusableView() }
                footer.footerClosure = {
                    let modalViewController = DetailCalendarViewController()
                    modalViewController.modalPresentationStyle = .overFullScreen
                    modalViewController.modalTransitionStyle = .crossDissolve
                    guard let id = self.userId else {return}
                    modalViewController.userId = id
                    modalViewController.movedateClosure = { [weak self] date in
                        self?.dismiss(animated: true)
                        self?.moveDateClosure?(date)
                    }
                    self.present(modalViewController, animated: false)
                }
                return footer
            }
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.headerMode = .supplementary
        config.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension MissionDetailViewController {
    
    @objc
    func deleteBtnTapped() {
        let modalViewController = HomeDeleteViewController()
        modalViewController.modalPresentationStyle = .overFullScreen
        modalViewController.modalTransitionStyle = .crossDissolve
        modalViewController.deleteClosure = {
            guard let id = self.userId else { return }
            self.requestDeleteMission(id: id)
        }
        present(modalViewController, animated: false)
    }
}

extension MissionDetailViewController {
    func requestDailyMissionAPI(id: Int) {
        HomeAPI.shared.getDailyDetailMission(id: id) { [weak self] result in
            switch result {
            case let .success(data):
                if let missionData = data as? MissionDetailResponseDTO {
                    print("data: \(missionData)")
                    self?.detailModel = [missionData]
                    self?.reloadData()
                } else {
                    print("Failed to cast data to MissionDetailResponseDTO")
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .requestErr:
                print("networkFail")
            }
        }
    }
    
    private func requestDeleteMission(id: Int) {
        HomeAPI.shared.deleteMission(id: id) { [weak self] _ in
            for index in 0..<(self?.detailModel.count ?? 0) {
                if self?.detailModel[index].id == id {
                    self?.deleteClosure?()
                    self?.reloadData()
                    self?.dismiss(animated: true)
                } else {}
            }
        }
    }
}
