//
//  ModalProtocol.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/06/01.
//

import UIKit

protocol ModalDelegate: AnyObject {
    func modalDismiss()
    func modalAction()
}
