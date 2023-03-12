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
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    // MARK: - UI Components
    private let containerView = UIView()
    private let horizontalStackview = UIStackView()
    private let cancelButton = UIButton()
    private let editButton = UIButton()
    
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
        containerView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 10 
        }
        cancelButton.do {
            $0.backgroundColor = .systemBlue
            $0.setImage(.delete, for: .normal)
        }
        editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray4, for: .normal)
            $0.titleLabel?.font = .Pretendard(.medium, size: 16)
        }
        horizontalStackview.do {
            $0.addArrangedSubviews(cancelButton, editButton)
            $0.axis = .horizontal
        }
    }
    
    private func setLayout() {
        view.addSubview(containerView)
        containerView.addSubview(horizontalStackview)
        
        cancelButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalTo(safeArea).offset(24)
        }
        editButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 35))
            $0.trailing.equalTo(safeArea).inset(17)
        }
        horizontalStackview.snp.makeConstraints {
            $0.directionalVerticalEdges.equalTo(safeArea)
            $0.top.equalToSuperview().offset(20)
        }
    }
}
