//
//  MyPageManagerImpl.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

final class MyPageManagerImpl: MyPageManger {
    
    private let authAPI: AuthServiceProtocol
    private let cancelBag = Set<AnyCancellable>()
    
    init(authAPI: AuthServiceProtocol) {
        self.authAPI = authAPI
    }
    
    func logout() -> AnyPublisher<Int, Error> {
        authAPI.logout()
            .eraseToAnyPublisher()
    }
    
    func withdrawl() -> AnyPublisher<Int, Error> {
        authAPI.withdrawal()
            .eraseToAnyPublisher()
    }
}
