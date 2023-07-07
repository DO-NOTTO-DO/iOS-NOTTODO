//
//  amplitudeProtocol.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/07/07.
//

import UIKit

import Amplitude

public protocol AnalyticsEventProtocol {

    var name: String { get }
  
    var parameters: [String: Any]? { get }
}

extension AnalyticsEventProtocol {

    var parameters: [String: Any]? { return nil }
}

public protocol AnalyticsServiceProtocol {

    func send(event: AnalyticsEventProtocol)
}
