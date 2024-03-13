//
//  ViewModel.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 3/13/24.
//

import Foundation

protocol ViewModel where Self: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
