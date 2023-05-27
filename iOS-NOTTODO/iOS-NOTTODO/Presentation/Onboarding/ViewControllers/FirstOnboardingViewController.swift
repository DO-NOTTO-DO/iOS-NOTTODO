//
//  FirstOnboardingViewController.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/05/27.
//

import UIKit

import SnapKit
import Then

class FirstOnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    // MARK: - UI Components
    
    private let logoImage = UIImageView()
    private let titleLabel = UILabel()
    private let nextButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension FirstOnboardingViewController {

    private func setUI() {
        view.backgroundColor = .ntdBlack
        logoImage.image = .logo
        
        titleLabel.do {
            $0.text = I18N.firstOnboarding
            $0.font = .Pretendard(.light, size: 22)
            $0.textColor = .white
            $0.numberOfLines = 0
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = $0.font.lineHeight * 0.2

            let attributedText = NSAttributedString(string: $0.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            $0.attributedText = attributedText
            $0.textAlignment = .center
        }
        
        nextButton.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
            $0.titleLabel?.font = .Pretendard(.semiBold, size: 16)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle(I18N.firstButton, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        view.addSubviews(logoImage, titleLabel, nextButton)
    
        logoImage.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(222)
            $0.centerX.equalTo(safeArea)
            $0.width.equalTo(118)
            $0.height.equalTo(77.92)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(45)
            $0.centerX.equalTo(safeArea)
        }
        
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
