//
//  MyPageManger.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

protocol MyPageManger {
    func logout() -> AnyPublisher<Void, Error>
    func withdrawl() -> AnyPublisher<Void, Error>
    func kakaoLogout()
    func kakaoWithdrawal()
}
