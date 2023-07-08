//
//  MyInfoAccountViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/18.
//

import UIKit

import KakaoSDKUser

class MyInfoAccountViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let navigationView = UIView()
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    private let seperateView = UIView()
    
    private let verticalStackView = UIStackView()
    private let nicknameView = MyInfoAccountStackView(title: I18N.nickname, isHidden: false)
    private let emailView = MyInfoAccountStackView(title: I18N.email, isHidden: false)
    private let accountView = MyInfoAccountStackView(title: I18N.account, isHidden: false)
    private let notificationView = MyInfoAccountStackView(title: I18N.notification, isHidden: true)
    
    private let logoutView = UIView()
    private let logoutButton = UIButton()
    private let withdrawButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.viewAccountInfo)
        setUI()
        setLayout()
        configure(model: MyInfoAccountModel(nickname: UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleUsername() : KeychainUtil.getKakaoUsername(), email: UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? KeychainUtil.getAppleEmail() : KeychainUtil.getKakaoEmail(), account: UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) ? "apple" : "kakao", notification: true))
    }
}

// MARK: - Methods

private extension MyInfoAccountViewController {
    func setUI() {
        
        self.notificationView.switchClosure = { result in
           if result {
               self.notificationView.notificationSwitch.setOn(result, animated: true)
           }
        }
        
        view.backgroundColor = .ntdBlack
        seperateView.backgroundColor = .gray2
        
        backButton.do {
            $0.setBackgroundImage(.icBack, for: .normal)
            $0.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
            $0.text = I18N.myInfoAccount
        }
        
        verticalStackView.do {
            $0.addArrangedSubviews(nicknameView, emailView, accountView, notificationView)
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .equalSpacing
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .gray1
        }
        
        logoutView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .gray1
        }
        
        logoutButton.do {
            $0.setTitle(I18N.logout, for: .normal)
            $0.setTitleColor(.ntdRed, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 14)
            $0.addTarget(self, action: #selector(tappedLogout), for: .touchUpInside)
        }
        
        withdrawButton.do {
            $0.setTitle(I18N.withdraw, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 12)
            $0.setUnderline()
            $0.addTarget(self, action: #selector(presentToWithdraw), for: .touchUpInside)
        }
    }
    
    func setLayout() {
        view.addSubviews(navigationView, seperateView, verticalStackView, logoutView, withdrawButton)
        navigationView.addSubviews(backButton, navigationTitle)
        logoutView.addSubview(logoutButton)
        
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
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(35)
            $0.directionalHorizontalEdges.equalToSuperview().inset(22)
        }
        
        logoutView.snp.makeConstraints {
            $0.top.equalTo(verticalStackView.snp.bottom).offset(21)
            $0.directionalHorizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(50)
        }
        
        logoutButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        withdrawButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-119)
        }
    }
    
    func configure(model: MyInfoAccountModel) {
        nicknameView.contentLabel.text = model.nickname
        emailView.contentLabel.text = model.email
        accountView.contentLabel.text = model.account
    }
    
    @objc
    private func presentToWithdraw() {
        let nextView = NottodoModalViewController()
        nextView.modalPresentationStyle = .overFullScreen
        nextView.modalTransitionStyle = .crossDissolve
        nextView.pushToRootAction = { [weak self] in
            if let window = self?.view.window?.windowScene?.keyWindow {
                let rootViewController = AuthViewController()
                self?.navigationController?.changeRootViewController(rootViewController)
            }
        }
        self.present(nextView, animated: true)
    }
    @objc
    private func tappedLogout() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.appearLogoutModal)
        
        let logoutAlert = UIAlertController(title: I18N.logoutAlertTitle, message: I18N.logoutAlertmessage, preferredStyle: UIAlertController.Style.alert)
        let logoutAction = UIAlertAction(title: I18N.logout, style: UIAlertAction.Style.default, handler: {_ in
            self.logout()
        })
        let cancelAlert = UIAlertAction(title: I18N.cancel, style: UIAlertAction.Style.default, handler: nil)
        logoutAlert.addAction(cancelAlert)
        logoutAlert.addAction(logoutAction)
        present(logoutAlert, animated: true, completion: nil)
        
    }
}

extension MyInfoAccountViewController {
    func logout() {
        if !UserDefaults.standard.bool(forKey: DefaultKeys.isAppleLogin) {
            kakaoLogout()
        } 
        AuthAPI.shared.deleteAuth { [weak self] _ in
            UserDefaults.standard.removeObject(forKey: DefaultKeys.accessToken)
            UserDefaults.standard.removeObject(forKey: DefaultKeys.socialToken)
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completeLogout)
            let authViewController = AuthViewController()
            if let window = self?.view.window?.windowScene?.keyWindow {
                let navigationController = UINavigationController(rootViewController: authViewController)
                navigationController.isNavigationBarHidden = true
                window.rootViewController = navigationController
            }
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
}
