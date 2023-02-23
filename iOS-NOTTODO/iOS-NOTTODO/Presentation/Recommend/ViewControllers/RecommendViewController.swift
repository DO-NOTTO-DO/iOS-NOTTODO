//
//  RecommendViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

class RecommendViewController: UIViewController {

    // MARK: - UI Components
    
    private lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let recommendInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 11, right: 15)
    let cellHeight: CGFloat = 137
    
    // test
    
    var recommendList: [RecommendModel] = [
        RecommendModel(tag: "업무 시간 중", title: "유튜브 보지 않기", body: "유튜브를 보지 않는 것이 당신의 일상에 어떠한 변화를 일으킬까요? 행복한 중독 해소를 위해 제안해요!", image: "img_youtube"),
        RecommendModel(tag: "취침 전", title: "커피 마시지 않기", body: "한국인들은 평균 2잔의 커피를 마신대요. 적당한 섭취를 위해 제안해요!", image: "img_coffee"),
        RecommendModel(tag: "기상 직후", title: "SNS 접속하지 않도록 하기", body: "도파민 중독에서 벗어나지 못하는 당신, 이제는 건강한 삶을 위해 절제해봐요. 중독 해소를 위한 건강한 제안!", image: "img_phone")
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

extension RecommendViewController {
    private func setUI() {
        view.backgroundColor = .black
    }
    
    private func setLayout() {
        view.addSubviews(recommendCollectionView)
        
        recommendCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127) // 수정하기
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        return layout
    }
    
    private func calculateCellHeight() -> CGFloat {
        let count = CGFloat(recommendList.count)
        return count * self.cellHeight + (count-1) * self.recommendInset.top + self.recommendInset.bottom
    }
    
    private func register() {
        recommendCollectionView.register(RecommendCollectionViewCell.self,
                                              forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
    }
    
    private func setDelegate() {
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
    }
}

extension RecommendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = recommendCollectionView.frame.width
        return CGSize(width: screenWidth, height: cellHeight)
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
