//
//  RecommendActionViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

import SnapKit
import Then

struct RecommendActionData {
    let tag: String
    let image: String
    let index: Int
    let selectedDate: String?
}

struct AddMissionData {
    var nottodo: String?
    var action: String?
    var situation: String?
    var date: [String]
    
    init(nottodo: String? = nil, action: String? = nil, situation: String? = nil, date: [String] = []) {
        self.nottodo = nottodo
        self.action = action
        self.situation = situation
        self.date = date
    }
}

final class RecommendActionViewController: UIViewController {
    
    // MARK: - Properties
    
    private var recommendActionList: [RecommendActions] = []
    private var addActionData = AddMissionData()
    var actionHeaderData: RecommendActionData?
    
    private weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    private let nextButton = UIButton()
    private var isTapped: Bool = false {
        didSet {
            setUI()
        }
    }
    
    private lazy var recommendActionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let recommendActionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    // MARK: - init
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        if let index = actionHeaderData?.index {
            requestRecommendActionAPI(index: index)
        }
        
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.RecommendDetail.viewRecommendMissionDetail(situation: addActionData.situation ?? "",
                                                                                                               title: addActionData.nottodo ?? ""))
    }
}

// MARK: - @objc

extension RecommendActionViewController {
    @objc
    private func pushToAddMission() {
        coordinator?.showAddViewController(data: self.addActionData, type: .add)
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
            $0.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.recommendNavTitle
        }
        
        nextButton.do {
            $0.isHidden = !isTapped
            $0.isUserInteractionEnabled = isTapped
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
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 11
        return layout
    }
    
    func register() {
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
    
    @objc
    func backButtonDidTapped() {
        coordinator?.popViewController()
    }
}

extension RecommendActionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = recommendActionCollectionView.dequeueReusableCell(withReuseIdentifier: RecommendActionCollectionViewCell.identifier, for: indexPath) as? RecommendActionCollectionViewCell else {
            return .zero
        }
        
        cell.bodyLabel.text = recommendActionList[indexPath.row].description
        cell.bodyLabel.sizeToFit()
        
        var cellHeight = cell.bodyLabel.frame.height + 56
        
        if cell.bodyLabel.text == nil {
            cellHeight = 49
        }
        
        return CGSize(width: collectionView.bounds.width - 30, height: cellHeight)
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return recommendActionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 227)
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
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendActionHeaderView.identifier, for: indexPath) as? RecommendActionHeaderView
            else { return UICollectionReusableView() }
            
            headerView.configure(data: self.actionHeaderData!, title: self.addActionData.nottodo )
            
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendActionFooterView.identifier, for: indexPath) as? RecommendActionFooterView
            else { return UICollectionReusableView() }
            
            footerView.clickedNextButton = { [weak self] in
                guard let self else { return }
                self.addActionData.action = ""
                coordinator?.showAddViewController(data: self.addActionData, type: .add)
            }
            
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension RecommendActionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isTapped = true
        addActionData.action = recommendActionList[indexPath.item].name
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.RecommendDetail.clickCreateRecommendMission(action: recommendActionList[indexPath.row].name,
                                                                                                                situation: addActionData.situation ?? "",
                                                                                                                title: addActionData.nottodo ?? ""))
        
    }
}

extension RecommendActionViewController {
    
    func requestRecommendActionAPI(index: Int) {
        RecommendActionAPI.shared.getRecommendAction(index: index) { [weak self] response in
            guard let self = self,
                  let response = response,
                  let data = response.data,
                  let selectedDate = self.actionHeaderData?.selectedDate,
                  let situation = self.actionHeaderData?.tag
            else { return }
            
            self.recommendActionList = data.recommendActions
            self.addActionData = AddMissionData(nottodo: data.title, situation: situation, date: [selectedDate])
            self.recommendActionCollectionView.reloadData()
        }
    }
}
