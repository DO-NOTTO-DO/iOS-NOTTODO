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

    private let detailView = UIView()
    private let horizontalStackview = UIStackView()
    private let cancelButton = UIButton()
    private let editButton = UIButton()
    private let popupView = PopUpView()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        popupView.appearPopUpView(subView: cancelButton, width: 50, height: 50)
    }
}

// MARK: - Methods

extension MissionDetailViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        popupView.addSubview(cancelButton)
        cancelButton.do {
            $0.backgroundColor = .systemBlue
            $0.setImage(.delete, for: .normal)
        }
    }
    private func setLayout() {
        
    }
}
