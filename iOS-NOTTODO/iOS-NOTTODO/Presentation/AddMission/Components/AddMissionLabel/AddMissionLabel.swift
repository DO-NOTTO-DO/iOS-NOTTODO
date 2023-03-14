//
//  AddMissionLabel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import Then

final class TitleLabel: UILabel {
    
    // MARK: - Life Cycle
    
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setUI() {
        font = .Pretendard(.regular, size: 15)
        textColor = .green1
    }
}

final class SubTitleLabel: UILabel {
    
    // MARK: - Properties
    
    var colorText: String
    
    // MARK: - Life Cycle
    
    init(subTitle: String, colorText: String) {
        self.colorText = colorText
        super.init(frame: .zero)
        self.text = subTitle
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setUI() {
        font = .Pretendard(.semiBold, size: 22)
        textColor = .white
        partColorChange(targetString: colorText, textColor: .green1!)
        textAlignment = .left
        numberOfLines = 0
    }
}
