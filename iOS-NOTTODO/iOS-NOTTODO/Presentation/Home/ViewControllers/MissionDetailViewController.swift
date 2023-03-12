//
//  MissionDetailViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/08.
//

import UIKit

import Then
import SnapKit

class MissionDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components

    private let containerView = UIView()
    private let popupView = PopUpView()

    private let horizontalStackView = UIStackView()
    private let cancelButton = UIButton()
    private let editButton = UIButton()
    
    private let missionVerticalStackView = UIStackView()
    private let missionTagLabel = PaddingLabel(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    private let missionLabel = UILabel()
    
    private let detailVerticalStackView = UIStackView()
    private let actionTag = UILabel()
    private let actionLabel = UILabel()
    private let goalTag = UILabel()
    private let goalLabel = UILabel()
    
    private let dateHorizontalStackView = UIStackView()
    private let dateLabel = UILabel()
    private let dateButton = UIButton()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Methods

extension MissionDetailViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        containerView.layer.cornerRadius = 10
        
        popupView.addSubview(cancelButton)
        
        horizontalStackView.do {
            $0.addArrangedSubviews(cancelButton, editButton)
            $0.axis = .horizontal
        }
        missionVerticalStackView.do {
            $0.addArrangedSubviews(missionTagLabel, missionLabel)
            $0.axis = .vertical
        }
        
        detailVerticalStackView.do {
            $0.addArrangedSubviews(actionTag, actionLabel, goalTag, goalLabel)
            $0.axis = .vertical
        }
        
        dateHorizontalStackView.do {
            $0.addArrangedSubviews(dateLabel, dateButton)
            $0.axis = .horizontal
        }
        
        cancelButton.do {
            $0.backgroundColor = .systemBlue
            $0.setImage(.delete, for: .normal)
        }
        
        editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
        }
        
    }
    private func setLayout() {
        
    }
}
