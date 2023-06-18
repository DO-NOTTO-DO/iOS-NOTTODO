//
//  LogoOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit
import ImageIO

class LogoOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    // MARK: - UI Components
    
    let gifImageView = UIImageView()
    private let nextButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        playGif()
    }
}

// MARK: - Methods

extension LogoOnboardingViewController {

    func playGif() {
        guard let gifURL = Bundle.main.url(forResource: "logo", withExtension: "gif") else {
            return
        }
        
        guard let source = CGImageSourceCreateWithURL(gifURL as CFURL, nil) else {
            return
        }
        
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        
        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            
            let image = UIImage(cgImage: cgImage)
            images.append(image)
        }
        
        gifImageView.animationImages = images
        gifImageView.animationDuration = TimeInterval(count) / 30.0
        gifImageView.animationRepeatCount = 1
        gifImageView.image = images.first
        
        DispatchQueue.main.async {
            self.gifImageView.startAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { [weak self] in
            self?.nextButton.isHidden = false
            self?.gifImageView.image = images.last
        }
    }
    
    private func setUI() {
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
        view.addSubviews(gifImageView, nextButton)
        
        gifImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(10)
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(15)
            $0.height.equalTo(50)
        }
    }

    @objc
    private func buttonTapped() {
        let nextViewController = SecondOnboardingViewController()
        navigationController?.pushViewController(nextViewController, animated: false)
    }
}
