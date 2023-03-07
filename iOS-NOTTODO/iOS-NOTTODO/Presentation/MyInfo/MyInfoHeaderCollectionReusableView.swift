//
//  MyInfoHeaderCollectionReusableView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

class MyInfoHeaderReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "MyInfoHeaderReusableView"
    
    // MARK: - UI Components
    
    private let myInfoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MyInfoHeaderReusableView {
    private func setUI() {
        myInfoLabel.do {
            $0.text = I18N.myInfo
            $0.font = .Pretendard(.semiBold, size: 18)
            $0.textColor = .white
        }
    }
    private func setLayout() {
        addSubview(myInfoLabel)
        
        myInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(21)
        }
    }
}
