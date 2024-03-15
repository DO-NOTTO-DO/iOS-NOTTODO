//
//  MyPageViewModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

protocol MyPageViewModellPresentable {}

protocol MyPageViewModel: ViewModel where Input == MyPageViewModelInput, Output == MyPageViewModelOutput {}

struct MyPageViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let profileCellTapped: PassthroughSubject<Void, Never>
}

struct MyPageViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<MyPageModel, Never>
}
