//
//  UIScreen+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/17.
//

import UIKit

extension UIScreen {
    var hasNotch: Bool {
        return !( (UIScreen.main.bounds.width / UIScreen.main.bounds.height) > 0.5 )
    }
}
