//
//  MyInfoAccountViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

import KakaoSDKUser
import UserNotifications

final class MyPageAccountViewModelImpl: MyPageAccountViewModel {
    
    private weak var coordinator: MypageCoordinator?
    private var manager: MyPageManger
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: MypageCoordinator, manager: MyPageManger) {
        self.coordinator = coordinator
        self.manager = manager
    }
    
    private let mypageAccountModel = CurrentValueSubject<MyPageAccountModel, Never>(MyPageAccountModel(profileData: AccountRowData.userInfo(), logout: AccountRowData.logout()))
    private let openNotificationSettings = PassthroughSubject<Void, Never>()
    
    func transform(input: MyPageAccountViewModelInput) -> MyPageAccountViewModelOutput {
        
        let viewWillAppearAndForeground = Publishers.Merge(input.viewWillAppearSubject, NotificationCenter.default.willEnterForeground.map { _ in })
        
        viewWillAppearAndForeground
            .flatMap { _ in
                self.getAuthorizationStatus()
                    .map { isAuthorized -> MyPageAccountModel in
                        var profileData = AccountRowData.userInfo()
                        let logoutData = AccountRowData.logout()
                        profileData[3].isOn = isAuthorized
                        return MyPageAccountModel(profileData: profileData, logout: logoutData)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] model in
                guard let self = self else { return }
                self.mypageAccountModel.send(model)
            })
            .store(in: &cancelBag)
        
        input.switchButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.openNotificationSettings.send(())
            }
            .store(in: &cancelBag)
        
        input.backButtonTapped
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.coordinator?.popViewController()
            })
            .store(in: &cancelBag)
        
        input.withdrawalTapped
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.coordinator?.showWithdrawViewController()
            })
            .store(in: &cancelBag)
        
        input.logoutTapped
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.appearLogoutModal)
                
                self.coordinator?.showLogoutAlertController { [weak self] in
                    self?.logout()
                }
            })
            .store(in: &cancelBag)
        
        return Output(viewWillAppearSubject: mypageAccountModel.eraseToAnyPublisher(), openNotificationSettings: openNotificationSettings.eraseToAnyPublisher())
    }
    
    private func logout() {
        manager.logout()
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { [weak self] _ in
                guard let self else { return }
                self.coordinator?.connectAuthCoordinator(type: .logout)
                AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completeLogout)
            })
            .store(in: &cancelBag)
    }
    
    private func getAuthorizationStatus() -> AnyPublisher<Bool, Never> {
        return Future { promise in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                promise(.success(settings.authorizationStatus == .authorized))
            }
        }
        .eraseToAnyPublisher()
    }
    
    deinit {
           cancelBag.forEach { $0.cancel() }
       }
}
