//
//  ValueOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit

import Lottie

class ValueOnboardingViewController: UIViewController {
    
    let animationView = LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation(named: "value") { [weak self] in
            self?.pushToNextViewController()
        }
    }
    
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
        let nextViewController = LogoOnboardingViewController()
        navigationController?.pushViewController(nextViewController, animated: false)
    }
}
