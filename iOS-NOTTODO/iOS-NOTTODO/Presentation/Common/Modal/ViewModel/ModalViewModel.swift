//
//  ModalViewModel.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/21/24.
//

import Foundation
import Combine

protocol ModalViewModelPresentable {}

protocol ModalViewModel: ViewModel where Input == ModalViewModelInput, Output == ModalViewModelOutput {}

struct ModalViewModelInput {
    let viewWillAppearSubject: PassthroughSubject<Void, Never>
    let modalDismiss: PassthroughSubject<Void, Never>
    let safariDismiss: PassthroughSubject<ViewType, Never>
    let safariPresent: PassthroughSubject<Void, Never>
}

struct ModalViewModelOutput {}
