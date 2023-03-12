//
//  MissionDetailViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

class MissionDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    enum Section {
        case mission
    }
    typealias Item = AnyHashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private let detailModel: [MissionDetailModel] = MissionDetailModel.items
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let horizontalStackview = UIStackView()
    private let emptyView = UIView()
    private let cancelButton = UIButton()
    private let editButton = UIButton()
    private let dimmendedView = PopUpView()
    private let deleteButton = UIButton(configuration: .filled())
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: - Life Cycle
    
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
        collectionView.register(DetailFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DetailFooterReusableView.identifier)
    }
    private func setUI() {
        
        view.backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 10
        }
        cancelButton.do {
            $0.backgroundColor = .clear
            $0.setImage(.icCancel, for: .normal)
            $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
        editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
        }
        horizontalStackview.do {
            $0.addArrangedSubviews(cancelButton, emptyView, editButton)
            $0.axis = .horizontal
        }
        deleteButton.do {
            $0.configuration?.title = "삭제하기"
//            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 3, leading: 6, bottom: 2, trailing: 7)
            $0.configuration?.cornerStyle = .capsule
            $0.configuration?.attributedTitle?.font = .Pretendard(.semiBold, size: 16)
            $0.configuration?.baseBackgroundColor = .black
            $0.configuration?.baseForegroundColor = .white
            $0.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        }
        collectionView.do {
            $0.bounces = false
            $0.isScrollEnabled = false
        }
    }
    
    private func setLayout() {
        dimmendedView.appearPopUpView(subView: view, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(containerView)
        containerView.addSubviews(horizontalStackview, collectionView, deleteButton)
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(60)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().offset(7)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 44, height: 35))
        }
        horizontalStackview.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(17)
            $0.top.equalToSuperview().offset(25)
            $0.height.equalTo(35)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalStackview.snp.bottom)
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
            cell.configure(model: item as! MissionDetailModel)
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
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DetailFooterReusableView.identifier, for: indexPath) as? DetailFooterReusableView else { return UICollectionReusableView() }
            footer.footerClosure = {
                print("tapped")
            }
            return footer
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension MissionDetailViewController {
    @objc
    func cancelButtonTapped() {
        dimmendedView.dissmissFromSuperview()
        self.dismiss(animated: true)
    }
    @objc
    func deleteBtnTapped() {
        print("tapped")
    }
}
