//
//  HomeViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension HomeViewController {
    private func setUI() {
        view.backgroundColor = .white
    }
}
