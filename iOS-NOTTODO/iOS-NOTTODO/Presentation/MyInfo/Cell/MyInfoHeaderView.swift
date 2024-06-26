//
//  MyInfoHeaderCollectionReusableView.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

final class MyInfoHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "MyInfoHeaderView"
    
    // MARK: - UI Components
    
    private let myInfoLabel = UILabel()
    
    // MARK: - Life Cycle
    
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

extension MyInfoHeaderView {
    
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
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
}
