//
//  MyPageViewModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/15/24.
//

import Foundation
import Combine

protocol MyPageViewModelPresentable {}

protocol MyPageViewModel: ViewModel where Input == MyPageViewModelInput, Output == MyPageViewModelOutput {}

struct MyPageViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let myPageCellTapped: PassthroughSubject<IndexPath, Never>
}

struct MyPageViewModelOutput {
    let viewWillAppearSubject: AnyPublisher<MyPageModel, Never>
    let openSafariController: AnyPublisher<String, Never>
}
