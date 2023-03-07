//
//  InfoCollectionViewCell.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "InfoCollectionViewCell"
    
    // MARK: - UI Components
    
    private let horizontalStackView = UIStackView()
    private let iconImage = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    convenience init(state: Bool) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension InfoCollectionViewCell {
    private func setUI() {
        backgroundColor = .clear

    }
    
    private func setLayout() {
  
    }
    
    func configure(model: MyInfoModel) {
       
    }
}

