//
//  NottodoModalViewController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/01.
//

import UIKit
import SnapKit
import KakaoSDKUser
import SafariServices

enum ViewType {
    case quit
    case quitSurvey
}

final class NottodoModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewType: ViewType? = .quit {
        didSet {
            setUI()
            setLayout()
        }
    }
    var dimissAction: (() -> Void)?
    var pushToRootAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private var modalView = UIView()
    private let withdrawView = WithdrawModalView()
    private let quitView = QuitModalView()
    private lazy var safariViewController = SFSafariViewController(url: URL(string: MyInfoURL.googleForm.url)!)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.appearWithdrawalModal)
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
        safariViewController.delegate = self
    }
}

extension NottodoModalViewController: ModalDelegate {
    func modalAction() {
        switch viewType {
        case .quitSurvey:
            self.present(safariViewController, animated: true) {
                self.withdrawal()
            }
        case .quit:
            viewType = .quitSurvey
            quitView.isHidden = true
        default:
            viewType = .quit
        }
    }
    
    func modalDismiss() {
        dismiss(animated: true)
        self.dimissAction?()
    }
}

extension NottodoModalViewController {
    func withdrawal() {
        if !KeychainUtil.getBool(DefaultKeys.isAppleLogin) {
            kakaoWithdrawal()
        }
        AuthAPI.shared.withdrawalAuth { _ in
            KeychainUtil.removeUserInfo()
            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completeWithdrawal)
        }
    }
    
    func kakaoWithdrawal() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
            }
        }
    }
}

extension NottodoModalViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismissViewController()
        self.pushToRootAction?()
    }
}
