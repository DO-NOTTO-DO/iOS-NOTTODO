//
//  UIStackView+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/23.
//

import UIKit

extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}
