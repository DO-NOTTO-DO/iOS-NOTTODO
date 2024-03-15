//
//  MyInfoAccountViewModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

protocol MyPageAccountViewModelPresentable {}

protocol MyPageAccountViewModel: ViewModel where Input == MyPageAccountViewModelInput, Output == MyPageAccountViewModelOutput {}

struct MyPageAccountViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let withdrawalTapped: PassthroughSubject<Void, Never>
    let logoutTapped: PassthroughSubject<Void, Never>
    let backButtonTapped: PassthroughSubject<Void, Never>
}

struct MyPageAccountViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<MyPageAccountModel, Never>
}
