//
//  LottieView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import Foundation

import UIKit
import Lottie

class LottieView: UIView {
    
    let animationView = LottieAnimationView()
    
    func playAnimation(named name: String) {
        let animation = LottieAnimation.named(name)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        
        animationView.frame = view.bounds
        view.addSubview(animationView)
        
        animationView.play()
    }
}
