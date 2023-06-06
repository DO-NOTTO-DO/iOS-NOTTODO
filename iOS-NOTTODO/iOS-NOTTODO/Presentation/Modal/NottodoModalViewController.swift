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
    
    // MARK: - Properties
    
    private var viewType: ViewType? = .quitSurvey {
        didSet {
            setUI()
            setLayout()
        }
    }
    var dimissAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private var modalView = UIView()
    private let withdrawView = WithdrawModalView()
    private let quitView = QuitModalView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !modalView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
}

extension NottodoModalViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        switch viewType {
        case .quit:
            modalView = quitView
        case .quitSurvey:
            modalView = withdrawView
        default:
            modalView = quitView
        }
    }
    
    private func setLayout() {
        view.addSubviews(modalView)
        
        modalView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(52)
        }
    }
    
    private func setDelegate() {
        quitView.delegate = self
        withdrawView.delegate = self
    }
}

extension NottodoModalViewController: ModalDelegate {
    func modalAction() {
        switch viewType {
        case .quitSurvey:
            Utils.myInfoUrl(vc: self, url: MyInfoURL.googleForm.url)
            viewType = .quit
            withdrawView.isHidden = true
        case .quit:
            let authViewController = AuthViewController()
            if let window = view.window?.windowScene?.keyWindow {
                let TabBarController = TabBarController()
                let navigationController = UINavigationController(rootViewController: authViewController)
                navigationController.isNavigationBarHidden = true
                window.rootViewController = navigationController
            }
        default:
            viewType = .quit
        }
    }
    
    func modalDismiss() {
        dismiss(animated: true)
        self.dimissAction?()
    }
}
