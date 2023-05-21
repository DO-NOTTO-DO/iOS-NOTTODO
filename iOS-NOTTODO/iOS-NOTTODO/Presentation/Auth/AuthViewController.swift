//
//  ViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit
import SnapKit
import Then

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import AuthenticationServices

class AuthViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var loginMainLabel = UILabel()
    private var loginSubLabel = UILabel()
    
    private var kakaoLoginImageView = UIImageView()
    private var kakaoLoginButtonView = AuthButtonView(frame: .zero, title: I18N.kakaoLogin, icon: .kakaoLogo, color: .kakaoYellow)
    private var appleLoginButtonView = AuthButtonView(frame: .zero, title: I18N.appleLogin, icon: .appleLogo, color: .white)
    private var kakaoLoginButton = UIButton()
    private var appleLoginButton = UIButton()
    
    private var moreLabel = UILabel()
    private var conditionButton = UIButton()
    private var personalInfoButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

extension AuthViewController {
    private func setUI() {
        view.backgroundColor = .ntdBlack
        loginMainLabel.do {
            $0.font = .Pretendard(.semiBold, size: 24)
            $0.textColor = .white
            $0.text = I18N.loginMain
            $0.numberOfLines = 2
        }
        
        loginSubLabel.do {
            $0.font = .Pretendard(.medium, size: 16)
            $0.textColor = .gray4
            $0.text = I18N.loginSub
            $0.numberOfLines = 2
        }
        
        kakaoLoginImageView.image = .kakaoLoginLabel
        
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonClicked), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonClicked), for: .touchUpInside)
        
        moreLabel.do {
            $0.text = I18N.moreAuth
            $0.textColor = .gray4
            $0.font = .Pretendard(.regular, size: 12)
        }
        
        conditionButton.do {
            $0.setTitle(I18N.condition, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 12)
            $0.setUnderline()
        }
        
        personalInfoButton.do {
            $0.setTitle(I18N.personalInfo, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 12)
            $0.setUnderline()
        }
    }
    
    private func setLayout() {
        
        view.addSubviews(loginMainLabel, loginSubLabel, kakaoLoginImageView, kakaoLoginButtonView, appleLoginButtonView, kakaoLoginButton, appleLoginButton, moreLabel)
        moreLabel.addSubviews(conditionButton, personalInfoButton)
        
        loginMainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(155)
            $0.leading.equalToSuperview().offset(29)
        }
        
        loginSubLabel.snp.makeConstraints {
            $0.top.equalTo(loginMainLabel.snp.bottom).offset(17)
            $0.leading.equalTo(loginMainLabel.snp.leading)
        }
        
        moreLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-65)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(moreLabel.snp.top).offset(-14)
        }

        kakaoLoginButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(appleLoginButtonView.snp.top).offset(-11)
        }
        
        kakaoLoginImageView.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButtonView.snp.top).offset(-9)
            $0.leading.equalToSuperview().offset(22)
            $0.width.equalTo(189)
            $0.height.equalTo(37)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(kakaoLoginButtonView)
        }

        appleLoginButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(appleLoginButtonView)
        }
        
        conditionButton.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        personalInfoButton.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
    }
    
    // MARK: - @objc Methods
    
    @objc func kakaoLoginButtonClicked() {
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginWithApp()
        } else {
            kakaoLoginWithAccount()
        }
    }
    
    @objc
    func appleLoginButtonClicked() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AuthViewController {
    
    func kakaoLoginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                
                UserApi.shared.me {(_, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let accessToken = AuthApi.shared.tokenManager.accessToken {
                            UserDefaults.standard.setValue(accessToken, forKey: "KakaoAccessToken")
                        }
                        self.presentToHomeViewController()
                    }
                }
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                UserApi.shared.me {(_, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let accessToken = AuthApi.shared.tokenManager.accessToken {
                            UserDefaults.standard.setValue(accessToken, forKey: "KakaoAccessToken")
                        }
                        self.presentToHomeViewController()
                    }
                }
            }
        }
    }
    
    func presentToHomeViewController() {
        let nextVC = HomeViewController()
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // 로그인 진행하는 화면 표출
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            self.presentToHomeViewController()
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
