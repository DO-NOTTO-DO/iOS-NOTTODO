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
    private var kakaoLoginButton = UIButton(configuration: .filled())
    private var appleLoginButton = UIButton(configuration: .filled())
    
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
        
        kakaoLoginButton.do {
            $0.configuration?.title = I18N.kakaoLogin
            $0.contentHorizontalAlignment = .leading
            $0.configuration?.image = .kakaoLogo
            $0.configuration?.imagePadding = 90
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.leading
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
            $0.configuration?.baseForegroundColor = .systemBlack
            $0.configuration?.baseBackgroundColor = .kakaoYellow
            $0.layer.cornerRadius = 5
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 14, bottom: 0, trailing: 0)
            $0.addTarget(self, action: #selector(kakaoLoginButtonClicked), for: .touchUpInside)
        }
        
        appleLoginButton.do {
            $0.configuration?.title = I18N.appleLogin
            $0.contentHorizontalAlignment = .leading
            $0.configuration?.image = .appleLogo
            $0.configuration?.imagePadding = 81
            $0.configuration?.imagePlacement = NSDirectionalRectEdge.leading
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
            $0.configuration?.baseForegroundColor = .systemBlack
            $0.configuration?.baseBackgroundColor = .white
            $0.layer.cornerRadius = 5
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 12, bottom: 0, trailing: 0)
            $0.addTarget(self, action: #selector(kakaoLoginButtonClicked), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        
        view.addSubviews(loginMainLabel, loginSubLabel, kakaoLoginImageView, kakaoLoginButton, appleLoginButton)
        
        loginMainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(155)
            $0.leading.equalToSuperview().offset(29)
        }
        
        loginSubLabel.snp.makeConstraints {
            $0.top.equalTo(loginMainLabel.snp.bottom).offset(17)
            $0.leading.equalTo(loginMainLabel.snp.leading)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-91)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(53)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-12)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(appleLoginButton.snp.height)
        }
        
        kakaoLoginImageView.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-10)
            $0.leading.equalToSuperview().offset(22)
            $0.width.equalTo(189)
            $0.height.equalTo(37)
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
        UserApi.shared.loginWithKakaoTalk {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                
                UserApi.shared.me {(_, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.presentToHomeViewController()
                    }
                }
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                UserApi.shared.me {(_, error) in
                    if let error = error {
                        print(error)
                    } else {
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
