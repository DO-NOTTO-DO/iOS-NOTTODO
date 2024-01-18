//
//  LogoOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit
import AVFoundation

final class LogoOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    // MARK: - UI Components
    
    private let animationView = UIImageView()
    private let nextButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playMp4Video()
    }
}

// MARK: - Methods

extension LogoOnboardingViewController {

    private func playMp4Video() {
        DispatchQueue.main.async { [weak self] in
            self?.playVideo(with: "logo")
        }
    }
    
    private func playVideo(with resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "mp4") else {
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = animationView.bounds
        animationView.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        player.play()
    }
    
    private func setUI() {
        view.backgroundColor = .ntdBlack
        
        nextButton.do {
            $0.isHidden = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle(I18N.firstButton, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        view.addSubviews(animationView, nextButton)
        
        animationView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(10)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func videoDidFinishPlaying(notification: NSNotification) {
        nextButton.isHidden = false
    }

    @objc
    private func buttonTapped() {
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.OnboardingClick.clickOnboardingStart)
       
        let nextViewController = SecondOnboardingViewController()
        navigationController?.pushViewController(nextViewController, animated: false)
    }
}
