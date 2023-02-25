//
//  RecommendActionViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/23.
//

import UIKit

class RecommendActionViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    let nextButton = UIButton()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}
    
    // MARK: - Methods
    
private extension RecommendActionViewController {
    func setUI() {
        view.backgroundColor = .ntdBlack
        // recommendCollectionView.backgroundColor = .clear
        
        backButton.do {
            $0.setBackgroundImage(.back, for: .normal)
            // $0.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.recommendNavTitle
        }
        
        nextButton.do {
            $0.setTitle(I18N.next, for: .normal)
            $0.setTitleColor(.gray1, for: .normal)
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 17.18) // 수정 필요
            $0.backgroundColor = .white
        }
    }
    
    func setLayout() {
        view.addSubviews(navigationView, nextButton)
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
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(76)
        }
    }
}
