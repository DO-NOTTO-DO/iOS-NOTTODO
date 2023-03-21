//
//  AddMissionFooterCollectionReusableView.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

final class AddMissionFooterCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "AddMissionFooterCollectionReusableView"
       
    // MARK: - UI Components
    
    private let tipImageView = UIImageView()
    private let tipLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddMissionFooterCollectionReusableView {
    func setUI() {
        tipImageView.image = .imgCreateTip
        
        tipLabel.do {
            $0.textColor = .gray4
            $0.font = .Pretendard(.regular, size: 14)
            $0.text = I18N.tipMessage
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
    func setLayout() {
        tipImageView.addSubview(tipLabel)
        addSubview(tipImageView)
        
        tipImageView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(29)
            $0.bottom.equalToSuperview().inset(22)
            $0.top.equalToSuperview().inset(80)
        }
        
        tipLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
