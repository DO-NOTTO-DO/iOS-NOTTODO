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
        
        cancelButton.do {
            $0.setImage(.delete, for: .normal)
        }
        
        
        
    }
    private func setLayout() {
        
    }
}
