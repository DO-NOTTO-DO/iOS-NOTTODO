//
//  MyPageManger.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

protocol MyPageManger {
    func logout() -> AnyPublisher<Int, Error>
    func withdrawl() -> AnyPublisher<Int, Error>
}
