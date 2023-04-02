//
//  RecommendViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

class RecommendViewController: UIViewController {

    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let dismissButton = UIButton()
    private let navigationTitle = UILabel()
    private let seperateView = UIView()
    private var addActionButton = UIButton()
    
    private lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let recommendInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    private let cellHeight: CGFloat = 137
    
    // test
    
    var recommendList: [RecommendModel] = [
        RecommendModel(tag: "업무 시간 중", title: "유튜브 보지 않기", body: "유튜브를 보지 않는 것이 당신의 일상에\n어떠한 변화를 일으킬까요?\n행복한 중독 해소를 위해 제안해요!", image: "img_youtube"),
        RecommendModel(tag: "취침 전", title: "커피 마시지 않기", body: "한국인들은 평균 2잔의 커피를 마신대요.\n적당한 섭취를 위해 제안해요!", image: "img_coffee"),
        RecommendModel(tag: "기상 직후", title: "SNS 접속하지 않도록 하기", body: "도파민 중독에서 벗어나지 못하는 당신,\n이제는 건강한 삶을 위해 절제해봐요.\n중독 해소를 위한 건강한 제안!", image: "img_insta"),
        RecommendModel(tag: "업무 시간 중", title: "유튜브 보지 않기", body: "유튜브를 보지 않는 것이 당신의 일상에\n어떠한 변화를 일으킬까요?\n행복한 중독 해소를 위해 제안해요!", image: "img_youtube"),
        RecommendModel(tag: "취침 전", title: "커피 마시지 않기", body: "한국인들은 평균 2잔의 커피를 마신대요.\n적당한 섭취를 위해 제안해요!", image: "img_coffee"),
        RecommendModel(tag: "기상 직후", title: "SNS 접속하지 않도록 하기", body: "도파민 중독에서 벗어나지 못하는 당신,\n이제는 건강한 삶을 위해 절제해봐요.\n중독 해소를 위한 건강한 제안!", image: "img_insta")
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
            // $0.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
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
            $0.layer.cornerRadius = 25
            // $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
