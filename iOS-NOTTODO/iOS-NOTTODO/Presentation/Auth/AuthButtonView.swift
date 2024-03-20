//
//  authButtonView.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/03/17.
//

import UIKit

import SnapKit
import Then

final class AuthButton: UIButton {
    
    // MARK: - UI Properties
    
    private let image = UIImageView()
    
    // MARK: - View Life Cycles
    
    init(frame: CGRect, title: String?, icon: UIImage?, color: UIColor?) {
        super.init(frame: frame)
        setUI(title: title, icon: icon, color: color)
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension AuthButton {
    private func setUI(title: String?, icon: UIImage?, color: UIColor?) {
        
        image.image = icon
        
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        
        var configuration = UIButton.Configuration.plain()
        
        configuration.title = title
        configuration.titleAlignment = .center
        configuration.attributedTitle?.font = .Pretendard(.medium, size: 16)
        configuration.baseBackgroundColor = color
        configuration.baseForegroundColor = .systemBlack
        configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        self.configuration = configuration
    }
    
    private func setLayout() {
        addSubviews(image)
        
        image.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }
}
