//
//  ViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import SnapKit
import Then

import AuthenticationServices
import Amplitude
import SafariServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class AuthViewController: UIViewController {
    
    // MARK: - Property
    
    private weak var coordinator: AuthCoordinator?
    
    // MARK: - UI Components
    
    private var loginMainLabel = UILabel()
    private var loginSubLabel = UILabel()
    
    private var kakaoLoginImageView = UIImageView()
    private var kakaoLoginButton = AuthButton(frame: .zero, title: I18N.kakaoLogin, icon: .kakaoLogo, color: .kakaoYellow)
    private var appleLoginButton = AuthButton(frame: .zero, title: I18N.appleLogin, icon: .appleLogo, color: .white)
    
    private var moreButton = UIButton()
    
    // MARK: - init
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.viewSignIn)
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
            $0.setLineSpacing(lineSpacing: $0.font.lineHeight * 0.2)
        }
        
        loginSubLabel.do {
            $0.font = .Pretendard(.medium, size: 16)
            $0.textColor = .gray4
            $0.text = I18N.loginSub
            $0.numberOfLines = 3
            $0.setLineSpacing(lineSpacing: $0.font.lineHeight * 0.2)
        }
        
        kakaoLoginImageView.image = .kakaoLoginLabel
        
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonClicked), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonClicked), for: .touchUpInside)
        
        moreButton.do {
            $0.setTitle(I18N.moreAuth, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.regular, size: 12)
            $0.setUnderlines(target: [I18N.condition, I18N.personalInfo])
            $0.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        
        view.addSubviews(loginMainLabel, loginSubLabel, kakaoLoginImageView, kakaoLoginButton, appleLoginButton, moreButton)
        
        loginMainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(155.adjusted)
            $0.leading.equalToSuperview().offset(29.adjusted)
        }
        
        loginSubLabel.snp.makeConstraints {
            $0.top.equalTo(loginMainLabel.snp.bottom).offset(17.adjusted)
            $0.leading.equalTo(loginMainLabel.snp.leading)
        }
        
        moreButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-65.adjusted)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17.adjusted)
            $0.bottom.equalTo(moreButton.snp.top).offset(-14.adjusted)
            $0.height.equalTo(53.adjusted)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(17.adjusted)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-11.adjusted)
            $0.height.equalTo(53.adjusted)
        }
        
        kakaoLoginImageView.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-9.adjusted)
            $0.leading.equalToSuperview().offset(22.adjusted)
            $0.width.equalTo(189.adjusted)
            $0.height.equalTo(37.adjusted)
        }
    }
    
    // MARK: - @objc Methods
    
    @objc func moreButtonTapped() {
        Utils.myInfoUrl(vc: self, url: MyInfoURL.service.url)
    }
    
    @objc func kakaoLoginButtonClicked() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.clickSignIn(provider: "kakao"))
        
        if UserApi.isKakaoTalkLoginAvailable() {
            kakaoLoginWithApp()
        } else {
            kakaoLoginWithAccount()
        }
    }
    
    @objc
    func appleLoginButtonClicked() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.clickSignIn(provider: "apple"))
        
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
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("kakaoLoginWithApp() success.")
                
                if let accessToken = oauthToken?.accessToken {
                    KeychainUtil.setSocialToken(accessToken)
                    self.getUserInfo()
                }
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("kakaoLoginWithAccount() success.")
                
                if let accessToken = oauthToken?.accessToken {
                    KeychainUtil.setSocialToken(accessToken)
                    self.getUserInfo()
                }
            }
        }
    }
    
    private func getUserInfo() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                let nickname = user?.kakaoAccount?.profile?.nickname
                let email = user?.kakaoAccount?.email
                
                KeychainUtil.setString(nickname, forKey: DefaultKeys.kakaoNickname)
                KeychainUtil.setString(email, forKey: DefaultKeys.kakaoEmail)
                KeychainUtil.setBool(false, forKey: DefaultKeys.isAppleLogin)
                
                let request = AuthRequest(socialToken: KeychainUtil.getSocialToken(), fcmToken: KeychainUtil.getFcmToken())
                AuthAPI.shared.postKakaoAuth(social: .KAKAO, request: request) { [weak self] result in
                    guard self != nil else { return }
                    guard result != nil else { return }
                    
                    AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.completeSignIn(provider: "kakao"))
                    
                    guard let accessToken = result?.data?.accessToken else { return }
                    guard let userId = result?.data?.userId else { return }
                    KeychainUtil.setAccessToken(accessToken)
                    Amplitude.instance().setUserId(userId)
                    self?.checkNotificationSettings()
                }
            }
        }
    }
    
    func presentToHomeViewController() {
        DispatchQueue.main.async {
            self.coordinator?.connectHomeCoordinator()
        }
    }   
    
    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self?.showNotiDialogView()
            default:
                self?.presentToHomeViewController()
            }
        }
    }
    
    func showNotiDialogView() {
        DispatchQueue.main.async {
            self.coordinator?.showNotificationViewController { [weak self] in
                guard let self else { return }
                self.requestNotification()
            }
        }
    }
    
    func requestNotification() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { isAllowed, _ in
            KeychainUtil.setBool(isAllowed, forKey: DefaultKeys.isNotificationAccepted)
            if isAllowed {
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickPushAllow(section: isAllowed))
            } else {
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickPushReject(section: isAllowed))
            }
            
            self.presentToHomeViewController()
        })
    }
}

// MARK: - AppleSignIn

extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            if let accessToken = appleIDCredential.identityToken {
                if let accessTokenString = String(data: accessToken, encoding: .utf8) {
                    KeychainUtil.setSocialToken(accessTokenString)
                }
            }
            
            let firstName = appleIDCredential.fullName?.givenName
            let lastName = appleIDCredential.fullName?.familyName
            if let firstName = firstName, let lastName = lastName {
                let fullName = "\(lastName)\(firstName)"
                KeychainUtil.setString(fullName, forKey: DefaultKeys.appleName)
            }
            
            if let email = appleIDCredential.email {
                KeychainUtil.setString(email, forKey: DefaultKeys.appleEmail)
            }
            
            KeychainUtil.setBool(true, forKey: DefaultKeys.isAppleLogin)

            let request = AuthRequest(socialToken: KeychainUtil.getSocialToken(), fcmToken: KeychainUtil.getFcmToken(), name: KeychainUtil.getAppleUsername())
            AuthAPI.shared.postAppleAuth(social: .APPLE, request: request) { [weak self] result in
                guard self != nil else { return }
                guard result != nil else { return }
                
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.Login.completeSignIn(provider: "apple"))
                guard let accessToken = result?.data?.accessToken else { return }
                guard let userId = result?.data?.userId else { return }
                KeychainUtil.setAccessToken(accessToken)
                Amplitude.instance().setUserId(userId)
                self?.checkNotificationSettings()
            }
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
