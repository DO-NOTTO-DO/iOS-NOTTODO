//
//  HomeDeleteViewController.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/06/25.
//

import UIKit

import SnapKit
import Then

final class HomeDeleteViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    var deleteClosure: (() -> Void)?
    
    // MARK: - UI Components
    
    private let deleteModalView = DeleteModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !self.view.frame.contains(location) {
            dismiss(animated: true)
        }
    }
}

// MARK: - Methods

extension HomeDeleteViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        deleteModalView.do {
            $0.deleteClosure = {
                self.deleteClosure?()
                self.dismiss(animated: true) 
            }
            $0.cancelClosure = {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func setLayout() {
        view.addSubview(deleteModalView)
        
        deleteModalView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(52)
            $0.height.equalTo((getDeviceWidth() - 104)*1.09)
            $0.center.equalTo(safeArea)
        }
    }
}
