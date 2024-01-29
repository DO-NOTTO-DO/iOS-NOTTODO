//
//  AmplitudeAnalyticsService.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/07/07.
//

import UIKit

import Amplitude

final class AmplitudeAnalyticsService: AnalyticsServiceProtocol {
    static let shared: AmplitudeAnalyticsService = AmplitudeAnalyticsService()
  
    init() {}
    
    func send(event: AnalyticsEventProtocol) {
        if let parameters = event.parameters {
            Amplitude.instance().logEvent(event.name, withEventProperties: parameters)
        } else {
            Amplitude.instance().logEvent(event.name)
        }
        
        #if DEBUG
        if let parameters = event.parameters {
            let params = parameters.compactMap { $0 }
            print("🍥🍥🍥🍥🍥 \(event.name) \(params) 🍥🍥🍥🍥🍥")
            return
        }
        print("🍥🍥🍥🍥🍥🍥 \(event.name) 🍥🍥🍥🍥🍥")
        #endif
    }
}
