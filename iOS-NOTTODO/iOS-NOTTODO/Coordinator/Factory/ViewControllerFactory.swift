//
//  ViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

protocol ViewControllerFactory: UpdateFlowcontrollerFactory, AuthFlowControllerFactory, HomeFlowControllerFactory, MyPageFlowControllerFactory, AchieveFlowControllerFactory, TabBarControllerFactory, AuthFlowControllerFactory {}

final class ViewControllerFactoryImpl: ViewControllerFactory {}
