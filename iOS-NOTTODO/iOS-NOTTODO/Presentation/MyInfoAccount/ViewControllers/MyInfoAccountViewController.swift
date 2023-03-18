//
//  MyInfoAccountViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/18.
//

import UIKit

class MyInfoAccountViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    private let seperateView = UIView()
    
    private let withdrawButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

private extension MyInfoAccountViewController {
    func setUI() {
        view.backgroundColor = .ntdBlack
        seperateView.backgroundColor = .gray2
        
        backButton.do {
            $0.setBackgroundImage(.icBack, for: .normal)
            // $0.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.myInfoAccount
        }
        
        withdrawButton.do {
            $0.setTitle(I18N.withdraw, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 12)
            $0.setUnderline()
        }
    }
    
    func setLayout() {
        view.addSubviews(navigationView, seperateView, withdrawButton)
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
        
        seperateView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-119)
        }
    }
}
