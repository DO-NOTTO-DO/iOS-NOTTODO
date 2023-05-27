//
//  FirstOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit

import Lottie

class LogoOnboardingViewController: UIViewController {
    
    let animationView = LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation(named: "logo") { [weak self] in
            self?.navigateToNextViewController()
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
    
    func navigateToNextViewController() {
        let nextViewController = SecondOnboardingViewController()
        self.present(nextViewController, animated: true, completion: nil)
    }
}
