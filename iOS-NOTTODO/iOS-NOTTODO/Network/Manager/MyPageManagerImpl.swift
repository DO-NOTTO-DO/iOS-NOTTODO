//
//  MyPageManagerImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

import KakaoSDKUser

final class MyPageManagerImpl: MyPageManger {
    
    private let authAPI: AuthServiceProtocol
    private let cancelBag = Set<AnyCancellable>()
    
    init(authAPI: AuthServiceProtocol) {
        self.authAPI = authAPI
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        authAPI.logout()
            .map { [weak self] _ in
                self?.kakaoLogout()
            }
            .eraseToAnyPublisher()
    }
    
    func withdrawl() -> AnyPublisher<Void, Error> {
        authAPI.withdrawal()
            .map { [weak self] _ in
                if !KeychainUtil.getBool(DefaultKeys.isAppleLogin) {
                    self?.kakaoWithdrawal()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
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
