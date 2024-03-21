//
//  NOTTODONavigationView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/20/24.
//

import UIKit

import SnapKit
import Then

protocol NavigationDelegate: AnyObject {
    func popViewController()
}

final class NottodoNavigationView: UIView {
    
    // MARK: - Property
    
    weak var delegate: NavigationDelegate?
    
    // MARK: - UI Components
    
    private let backButton = UIButton()
    private let navigationTitle = UILabel()
    private let seperateView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NottodoNavigationView {
    
    private func setUI() {
        
        seperateView.do {
            $0.backgroundColor = .gray2
        }
        backButton.do {
            $0.setBackgroundImage(.icBack, for: .normal)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        navigationTitle.do {
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
    }
    
    private func setLayout() {
        self.addSubviews(backButton, navigationTitle, seperateView)
        
        self.snp.makeConstraints {
            $0.height.equalTo(58)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        seperateView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.7)
        }
    }
    
    func setTitle(_ text: String) {
        navigationTitle.text = text
    }
    
    @objc
    private func backButtonTapped() {
        delegate?.popViewController()
    }
}
