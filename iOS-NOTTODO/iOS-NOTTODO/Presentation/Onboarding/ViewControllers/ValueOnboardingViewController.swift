//
//  ValueOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit

import Lottie

final class ValueOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var coordinator: AuthCoordinator
      
    // MARK: - UI Properties
    
    let animationView = LottieAnimationView()
    
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
        playAnimation(named: "value") { [weak self] in
            self?.pushToNextViewController()
        }
    }
}

// MARK: - Methods

extension ValueOnboardingViewController {
    
    func playAnimation(named name: String, completion: @escaping () -> Void) {
        let animation = LottieAnimation.named(name)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        
        animationView.frame = view.bounds
        view.addSubview(animationView)
        
        animationView.play { _ in
            completion()
        }
    }
    
    func pushToNextViewController() {
        coordinator.showLogoOnboardingViewController()
    }
}
