//
//  ViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

import SnapKit
import Then

final class AuthViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var loginMainLabel = UILabel()
    private var loginSubLabel = UILabel()
    private var kakaoLoginImageView = UIImageView()
    // private var kakaoLoginButton = UIButton(configuration: .plain())
    private var kakaoLoginButton = UIButton()
    private var appleLoginButton = UIButton()
    lazy var kakaoAuthModel: KakaoAuthModel = { KakaoAuthModel() }()
    
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
            // $0.font = .PretendardSemiBold(size: 24)
            $0.textColor = .white
            // $0.textAlignment = .center
            $0.text = "나만을 위한 추천과 \n안전한 데이터 보관의 시작!" // I18N.login
            $0.numberOfLines = 2
        }
        
        loginSubLabel.do {
            // $0.font = .PretendardMedium(size: 16)
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
        
        appleLoginButton.setBackgroundImage(UIImage(named: "btn_login_forapple"), for: .normal)
        
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
        print("kakao login button clicked")
        kakaoAuthModel.KakaoLogin()
    }
}
