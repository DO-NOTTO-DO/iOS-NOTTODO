//
//  UpdateFlowcontrollerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 3/23/24.
//

import Foundation

protocol UpdateFlowcontrollerFactory {
    func makeUpdateCheckViewController(coordinator: UpdateCoordinator) -> UpdateCheckViewController
}
