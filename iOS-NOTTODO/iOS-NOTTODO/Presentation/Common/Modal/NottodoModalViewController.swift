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
    case logout
}

final class NottodoModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var coordinator: MypageCoordinator?
    
    private var viewType: ViewType? = .quit {
        didSet {
            setUI()
            setLayout()
        }
    }
    
    // MARK: - UI Components
    
    private var modalView = UIView()
    private let withdrawView = WithdrawModalView()
    private let quitView = QuitModalView()
    private lazy var safariViewController = SFSafariViewController(url: URL(string: MyInfoURL.commonAlarmModal.url)!)
    
    // MARK: - init
    
    init(coordinator: MypageCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            coordinator?.dismiss()
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
        coordinator?.dismiss() // 탈퇴 alert 취소
    }
}

extension NottodoModalViewController {
    func withdrawal() {
        if !KeychainUtil.getBool(DefaultKeys.isAppleLogin) {
            kakaoWithdrawal()
        }
        AuthService.shared.withdrawalAuth { _ in
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
        controller.delegate = nil
        coordinator?.connectAuthCoordinator(type: .quitSurvey)
    }
}
