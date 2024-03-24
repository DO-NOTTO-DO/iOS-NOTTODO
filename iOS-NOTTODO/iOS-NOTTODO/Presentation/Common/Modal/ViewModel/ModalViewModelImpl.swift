//
//  ModalViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/21/24.
//

import Foundation
import Combine

final class ModalViewModelImpl: ModalViewModel {
    
    private weak var coordinator: MypageCoordinator?
    private var manager: MyPageManger
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: MypageCoordinator, manager: MyPageManger) {
        self.coordinator = coordinator
        self.manager = manager
    }
    
    func transform(input: ModalViewModelInput) -> ModalViewModelOutput {
        
        input.viewWillAppearSubject
            .sink { _ in
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.appearWithdrawalModal)
            }
            .store(in: &cancelBag)
        
        input.modalDismiss
            .sink { [weak self] _ in
                self?.coordinator?.dismiss()
            }
            .store(in: &cancelBag)
        
        input.safariDismiss
            .sink { [weak self] type in
                self?.coordinator?.connectAuthCoordinator(type: type)
            }
            .store(in: &cancelBag)
        
        input.safariPresent
            .sink { [weak self] _ in
                self?.withdrawal()
            }
            .store(in: &cancelBag)
        return Output()
    }
    
    func withdrawal() {
        manager.withdrawl()
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { _ in
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completeWithdrawal)
            })
            .store(in: &cancelBag)
    }
}
