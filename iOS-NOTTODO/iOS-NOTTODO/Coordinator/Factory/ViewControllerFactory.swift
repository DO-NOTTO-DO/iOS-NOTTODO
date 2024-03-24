//
//  ViewControllerFactory.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2/18/24.
//

import UIKit

protocol ViewControllerFactory: UpdateFlowcontrollerFactory, AuthFlowControllerFactory, HomeFlowControllerFactory, AchieveFlowControllerFactory, TabBarControllerFactory, AuthFlowControllerFactory, MyPageFlowControllerFactory {}

final class ViewControllerFactoryImpl: ViewControllerFactory {}
