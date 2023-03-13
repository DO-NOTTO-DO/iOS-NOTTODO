//
//  DetailCalendarViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/13.
//

import UIKit

class DetailCalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private let completeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension DetailCalendarViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        completeButton.do {
            $0.setTitle(I18N.detailComplete, for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
            $0.addTarget(self, action: #selector(completeBtnTapped(sender:)), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        view.addSubviews(completeButton)
        
        completeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(CGSize(width: 44, height: 35))
        }
    }
}

extension DetailCalendarViewController {
    @objc
    func completeBtnTapped(sender: UIButton) {
        print("완료")
    }
}
