//
//  MyInfoViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

final class MyInfoViewController: UIViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension MyInfoViewController {
    private func setUI() {
        view.backgroundColor = .white
    }
}
