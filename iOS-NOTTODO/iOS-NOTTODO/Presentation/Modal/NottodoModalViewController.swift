//
//  NottodoModalViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/01.
//

import UIKit
import SnapKit

enum ViewType {
    case quit
    case quitSurvey
}

final class NottodoModalViewController: UIViewController {
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }

}

extension NottodoModalViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private func setLayout() {
        
    }
}
