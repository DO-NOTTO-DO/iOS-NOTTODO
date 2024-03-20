//
//  UIButton+.swift
//  iOS-NOTTODO
//
//  Created by 김민서 on 2023/02/26.
//

import UIKit

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
    
    func setUnderlines(target: [String]) {
        guard let title = titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: title)
        target.forEach {
            let range = (title as NSString).range(of: $0)
            attributedString.addAttribute(
                .underlineStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: range)
        }
        setAttributedTitle(attributedString, for: .normal)
    }
}
