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
import Combine

enum ViewType {
    case quit
    case quitSurvey
    case logout
}

final class NottodoModalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let modalViewControllerDismiss = PassthroughSubject<Void, Never>()
    private let safariDismiss = PassthroughSubject<ViewType, Never>()
    private let safariPresent = PassthroughSubject<Void, Never>()
    private var viewModel: any ModalViewModel

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
    
    init(viewModel: some ModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearSubject.send(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDelegate()
        setBindings()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        if !modalView.frame.contains(location) {
            modalViewControllerDismiss.send(())
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
    
    private func setBindings() {
        let input = ModalViewModelInput(viewWillAppearSubject: viewWillAppearSubject,
                                        modalDismiss: modalViewControllerDismiss,
                                        safariDismiss: safariDismiss,
                                        safariPresent: safariPresent)
        
        _ = viewModel.transform(input: input)
    }
}

extension NottodoModalViewController: ModalDelegate {
    func modalAction() {
        switch viewType {
        case .quitSurvey:
            self.present(safariViewController, animated: true) {
                self.safariPresent.send(())
            }
        case .quit:
            viewType = .quitSurvey
            quitView.isHidden = true
        default:
            viewType = .quit
        }
    }
    
    func modalDismiss() {
        modalViewControllerDismiss.send(())
    }
}

extension NottodoModalViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.delegate = nil
        safariDismiss.send(.quitSurvey)
    }
}
