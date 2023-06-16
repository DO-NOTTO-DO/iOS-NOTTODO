//
//  RecommendActionViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

class RecommendActionViewController: UIViewController {
    
    // MARK: - Properties
    
    var recommendActionResponse: RecommendActionResponseDTO?
    var recommendActionList: [RecommendActions] = []
    var selectedIndex: Int = 0
    var tagLabelText: String?
    var bodyImageUrl: UIImage?
    var nottodoTitle: String?
    var actionLabel: String?
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    private let nextButton = UIButton()
    private var isTapped: Bool = false
    
    private lazy var recommendActionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let recommendActionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        register()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestRecommendActionAPI()
    }
}

// MARK: - @objc

extension RecommendActionViewController {
    @objc
    private func pushToAddMission() {
        let nextViewController = AddMissionViewController()
        nextViewController.setNottodoLabel(nottodoTitle ?? "")
        nextViewController.setActionLabel(actionLabel ?? "")
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: - Methods

private extension RecommendActionViewController {
    
    func setUI() {
        view.backgroundColor = .ntdBlack
        
        recommendActionCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
            //            $0.allowsMultipleSelection = true  생성뷰 이슈 해결 후 주석 해제
        }
        
        backButton.do {
            $0.setBackgroundImage(.back, for: .normal)
            $0.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.recommendNavTitle
        }
        
        nextButton.do {
            $0.isHidden = isTapped ? false : true
            $0.isUserInteractionEnabled = isTapped ? true : false
            $0.setTitle(I18N.next, for: .normal)
            $0.setTitleColor(.gray1, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 17.18) // 수정 필요
            $0.backgroundColor = .white
            $0.addTarget(self, action: #selector(pushToAddMission), for: .touchUpInside)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(76)
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 11
        return layout
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
        recommendActionCollectionView.delegate = self
        recommendActionCollectionView.dataSource = self
    }
    
    func requestRecommendActionAPI() {
        RecommendActionAPI.shared.getRecommendAction(index: selectedIndex) { [weak self] response in
            guard self != nil else { return }
            guard let response = response else { return }
            guard let data = response.data else { return }
            
            self?.recommendActionList = data.recommendActions
            self?.recommendActionCollectionView.reloadData()
        }
    }
}

extension RecommendActionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = recommendActionCollectionView.dequeueReusableCell(withReuseIdentifier: RecommendActionCollectionViewCell.identifier, for: indexPath) as? RecommendActionCollectionViewCell else {
            return .zero
        }
        cell.titleLabel.text = recommendActionList[indexPath.row].name
        cell.titleLabel.sizeToFit()
        
        let cellHeight = cell.bodyLabel.frame.height + 56
        
        return CGSize(width: collectionView.bounds.width - 30, height: cellHeight)
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return recommendActionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 68)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendActionHeaderView.identifier, for: indexPath) as? RecommendActionHeaderView else { return UICollectionReusableView() }
            RecommendActionAPI.shared.getRecommendAction(index: selectedIndex) { [weak self] response in
                guard self != nil else { return }
                guard let response = response else { return }
                guard let data = response.data else { return }
                headerView.configure(tag: self?.tagLabelText, title: data.title, image: self?.bodyImageUrl)
                self?.nottodoTitle = headerView.getTitle()
            }
            
            return headerView
        } else {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendActionFooterView.identifier, for: indexPath) as? RecommendActionFooterView else { return UICollectionReusableView() }
            footerView.clickedNextButton = { [weak self] in
                let nextViewContoller = AddMissionViewController()
                nextViewContoller.setNottodoLabel(self?.nottodoTitle ?? "")
                self?.navigationController?.pushViewController(nextViewContoller, animated: true)
            }
            return footerView
        }
    }
}

extension RecommendActionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let select = collectionView.indexPathsForSelectedItems {
            if select.count > 0 {
                self.isTapped = true
                setUI()
                setDelegate()
            }
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecommendActionCollectionViewCell else { fatalError() }
        actionLabel = cell.titleLabel.text
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let deSelect = collectionView.indexPathsForSelectedItems {
            if deSelect.count == 0 {
                self.isTapped = false
                setUI()
                setDelegate()
            }
        }
        actionLabel = ""
    }
}
