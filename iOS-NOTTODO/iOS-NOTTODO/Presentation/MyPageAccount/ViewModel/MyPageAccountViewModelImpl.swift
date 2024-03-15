//
//  MyInfoAccountViewModelImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

import KakaoSDKUser

final class MyPageAccountViewModelImpl: MyPageAccountViewModel {
    
    private weak var coordinator: MypageCoordinator?
    private var manager: MyPageManger
    private var cancelBag = Set<AnyCancellable>()
    
    init(coordinator: MypageCoordinator, manager: MyPageManger) {
        self.coordinator = coordinator
        self.manager = manager
    }
        
    func transform(input: MyPageAccountViewModelInput) -> MyPageAccountViewModelOutput {
        
      let viewWillAppearSubject =  input.viewWillAppearSubject
            .map { _ -> MyPageAccountModel in
                return MyPageAccountModel(profileData: AccountRowData.userInfo(), logout: AccountRowData.logout())
            }
            .eraseToAnyPublisher()
        
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
                self.coordinator?.showLogoutAlertController {
                    print("Tapped logout ")
                }
            })
            .store(in: &cancelBag)
    
        return Output(viewWillAppearSubject: viewWillAppearSubject)
    }
    
    func logout() {
        manager.logout()
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { data in
                dump(data)
            })
            .store(in: &cancelBag)
    }
    
    func withdrawal() {
        manager.withdrawl()
            .sink(receiveCompletion: { event in
                print("completion: \(event)")
            }, receiveValue: { data in
                dump(data)
            })
            .store(in: &cancelBag)
    }
    
    //    func logout() {
    //        if !KeychainUtil.getBool(DefaultKeys.isAppleLogin) {
    //            kakaoLogout()
    //        }
    //
    //        AuthService.shared.deleteAuth { [weak self] _ in
    //            guard let self else { return }
    //            self.coordinator?.connectAuthCoordinator(type: .logout )
    //
    //            AmplitudeAnalyticsService.shared.send(event: AnalyticsEvent.AccountInfo.completeLogout)
    //        }
    //    }
    //
    //    func kakaoLogout() {
    //        UserApi.shared.logout {(error) in
    //            if let error = error {
    //                print(error)
    //            } else {
    //                print("logout() success.")
    //            }
    //        }
    //    }
}
