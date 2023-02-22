//
//  UIFont+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/15.
//

import UIKit

extension UIFont {
    
    // MARK: - Pretendard Font
    
    public enum PretendardType: String {
        case semiBold = "SemiBold"
        case regular = "Regular"
        case light = "Light"
        case medium = "Medium"
    }
    
    static func Pretendard(_ type: PretendardType, size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-\(type.rawValue)", size: size)!
    }
}
