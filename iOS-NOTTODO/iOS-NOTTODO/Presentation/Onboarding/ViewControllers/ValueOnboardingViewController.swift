//
//  ValueOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit

import Combine
import Lottie

final class ValueOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: any ValueOnboardingViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private let endAnimationSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - UI Properties
    
    let animationView = LottieAnimationView()
    
    // MARK: - init
    
    init(viewModel: some ValueOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation(named: "value") { [weak self] in
            self?.endAnimationSubject.send()
        }
        setBindings()
    }
    
    deinit {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}

// MARK: - Methods

extension ValueOnboardingViewController {
    
    private func playAnimation(named name: String, completion: @escaping () -> Void) {
        let animation = LottieAnimation.named(name)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        
        animationView.frame = view.bounds
        view.addSubview(animationView)
        
        animationView.play { [weak self] _ in
            self?.animationView.removeFromSuperview() // 애니메이션 뷰 제거
            completion()
        }
    }
    
    private func setBindings() {
        let input = ValueOnboardingViewModelInput(
            endAnimationSubject: endAnimationSubject)
        _ = viewModel.transform(input: input)
    }
}
