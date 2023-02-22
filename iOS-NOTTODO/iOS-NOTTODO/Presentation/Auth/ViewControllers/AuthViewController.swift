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
    // private var kakaoLoginButton = UIButton(configuration: .plain())
    private var kakaoLoginButton = UIButton()
    private var appleLoginButton = UIButton()
    
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
            $0.font = .Pretandard(.semiBold, size: 24)
            $0.textColor = .white
            $0.text = "나만을 위한 추천과 \n안전한 데이터 보관의 시작!" // I18N.login
            $0.numberOfLines = 2
        }
        
        loginSubLabel.do {
            $0.font = .Pretandard(.medium, size: 16)
            $0.textColor = .gray4
            $0.text = "계정을 연동하면 언제 어디서든 \n낫투두 기록을 관리할 수 있어요." // I18N.agreeLogin
            $0.numberOfLines = 2
        }
        
        kakaoLoginImageView.image = UIImage(named: "label_login_kakao") // .label_login_kakao
        
        //        kakaoLoginButton.do {
        //            $0.configuration?.title = "카카오 로그인"
        //            $0.configuration?.image = icon ?? nil
        //            $0.configuration?.titleAlignment = .leading
        //            $0.titleLabel?.font = .PretendardMedium(size: 16)
        //            $0.configuration?.baseForegroundColor = .systemBlack
        //            $0.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
        //            $0.configuration?.buttonSize = .small
        //            $0.configuration?.baseBackgroundColor = .yellow
        //            $0.configuration?.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        //        }
        
        kakaoLoginButton.do {
            $0.setBackgroundImage(UIImage(named: "btn_login_forkakao"), for: .normal)
            $0.addTarget(self, action: #selector(kakaoLoginButtonClicked), for: .touchUpInside)
        }
        
        appleLoginButton.do {
            $0.setBackgroundImage(UIImage(named: "btn_login_forapple"), for: .normal)
            $0.addTarget(self, action: #selector(appleLoginButtonClicked), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        
        [loginMainLabel, loginSubLabel, kakaoLoginImageView, kakaoLoginButton, appleLoginButton].forEach {
            view.addSubview($0)
        }
        
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
            $0.centerX.equalToSuperview()
            $0.width.equalTo(342)
            $0.height.equalTo(53)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(appleLoginButton.snp.width)
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
                
                UserApi.shared.me {(user, error) in
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
                
                UserApi.shared.me {(user, error) in
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
