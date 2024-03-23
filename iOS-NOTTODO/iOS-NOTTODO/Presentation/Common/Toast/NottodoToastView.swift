//
//  NottodoToastView.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/27.
//

import UIKit

import SnapKit
import Then

final class NottodoToastView: UIView {
    
    // MARK: - Properties
    
    private var message: String?
    
    // MARK: - UI Components
    
    private let errorImage = UIImageView()
    private let errorMessage = UILabel()
    
    init(message: String, viewController: UIViewController) {
        self.message = message
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NottodoToastView {
    private func setUI() {
        backgroundColor = .white
        makeCornerRound(radius: 12)
        layer.makeShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 30, spread: 0)
        isUserInteractionEnabled = false
        
        errorImage.image = .icToastError
        
        errorMessage.do {
            $0.text = message
            $0.textColor = .gray2
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = .Pretendard(.regular, size: 14)
        }
    }
    
    private func setLayout() {
        addSubviews(errorImage, errorMessage)
        
        errorImage.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(16)
        }
        
        errorMessage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.leading.equalTo(errorImage.snp.trailing).offset(6)
        }
    }
}
