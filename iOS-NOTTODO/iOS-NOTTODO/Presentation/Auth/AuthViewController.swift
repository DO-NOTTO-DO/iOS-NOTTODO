//
//  ViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension AuthViewController {
    private func setUI() {
        view.backgroundColor = .ntdBlack
    }
}
