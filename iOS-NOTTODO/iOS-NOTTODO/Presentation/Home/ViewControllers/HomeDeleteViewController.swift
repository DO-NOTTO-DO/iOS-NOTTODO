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
    
    var deleteClosure: (() -> Void)?
    
    private var coordinator: HomeCoordinator
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Components
    
    private let deleteModalView = DeleteModalView()
    
    // MARK: - init
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !deleteModalView.frame.contains(location) {
            coordinator.dismissLastPresentedViewController()
        }
    }
}

// MARK: - Methods

extension HomeDeleteViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        deleteModalView.do {
            $0.deleteClosure = { [weak self] in
                guard let self else { return }
                self.deleteClosure?()
            }
            
            $0.cancelClosure = { [weak self] in
                guard let self else { return }
                self.coordinator.dismissLastPresentedViewController()
            }
        }
    }
    
    private func setLayout() {
        view.addSubview(deleteModalView)
        
        deleteModalView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(safeArea).inset(52)
            $0.height.equalTo((Numbers.width - 104)*1.09)
            $0.center.equalTo(safeArea)
        }
    }
}
