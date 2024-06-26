//
//  RecommendViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

final class RecommendViewController: UIViewController {
    
    // MARK: - Properties
    
    var recommendResponse: RecommendResponseDTO?
    var recommendList: [RecommendResponseDTO] = []
    private var selectDay: String?
    
    private weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let dismissButton = UIButton()
    private let navigationTitle = UILabel()
    private let seperateView = UIView()
    private var addActionButton = UIButton()
    
    private lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let recommendInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    private let cellHeight: CGFloat = 137
    
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
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Recommend.viewRecommendMission)
        setUI()
        setLayout()
        register()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestRecommendAPI()
    }
    
    func setSelectDate(_ date: String) {
        selectDay = date
    }
}

// MARK: - Methods

private extension RecommendViewController {
    func setUI() {
        view.backgroundColor = .ntdBlack
        seperateView.backgroundColor = .gray2
        
        recommendCollectionView.do {
            $0.backgroundColor = .clear
            $0.bounces = false
        }
        
        dismissButton.do {
            $0.setBackgroundImage(.delete, for: .normal)
            $0.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.recommendNavTitle
        }
        
        addActionButton.do {
            $0.backgroundColor = .white
            $0.setTitle(I18N.addAction, for: .normal)
            $0.setTitleColor(.ntdBlack, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.makeCornerRound(radius: 25)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setLayout() {
        view.addSubviews(navigationView, seperateView, recommendCollectionView, addActionButton)
        navigationView.addSubviews(dismissButton, navigationTitle)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        dismissButton.snp.makeConstraints {
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
        
        addActionButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        recommendCollectionView.snp.makeConstraints {
            $0.top.equalTo(seperateView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addActionButton.snp.top).offset(-9)
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 11
        return layout
    }
    
    private func register() {
        recommendCollectionView.register(RecommendCollectionViewCell.self,
                                         forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
    }
    
    func setDelegate() {
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
    }
    
    func requestRecommendAPI() {
        RecommendService.shared.getRecommend { [weak self] response in
            guard let self else { return }
            guard let response = response else { return }
            
            guard let data = response.data else { return }
            self.recommendList = data
            self.recommendCollectionView.reloadData()
        }
    }
    
    @objc
    private func buttonTapped() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Recommend.clickSelfCreateMission)
        let data: AddMissionData = AddMissionData(date: [selectDay ?? ""])
        coordinator?.showAddViewController(data: data, type: .add)
    }
}

extension RecommendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 30, height: cellHeight)
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return recommendInset
    }
}

extension RecommendViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath)
                as? RecommendCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(model: recommendList[indexPath.row])
        return cell
    }
}

extension RecommendViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Recommend.clickRecommendMission(situation: recommendList[indexPath.row].situation, title: recommendList[indexPath.row].title))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let indexPath = self.recommendList[indexPath.item]
            let data = RecommendActionData(tag: indexPath.situation,
                                           image: indexPath.image,
                                           index: indexPath.id,
                                           selectedDate: self.selectDay)
            self.coordinator?.showRecommendDetailViewController(actionData: data)
        }
    }
}

extension RecommendViewController {
    
    @objc
    private func dismissViewController() {
        coordinator?.dismissRecommendViewcontroller()
    }
}
