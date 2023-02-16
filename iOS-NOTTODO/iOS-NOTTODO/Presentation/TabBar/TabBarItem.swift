//
//  TabBarItem.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/17.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case home
    case achievement
    case mypage
}

extension TabBarItemType {
    var selectedIcon: UIImage {
        switch self {
        case .home:
            return .homeOn
        case .achievement:
            return .calendarOn
        case .mypage:
            return .mypageOn
        }
    }
    
    var unselectedIcon: UIImage {
        switch self {
        case .home:
            return .homeOff
        case .achievement:
            return .calendarOff
        case .mypage:
            return .mypageOff
        }
    }
    
    public func setTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: nil,
            image: unselectedIcon.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedIcon.withRenderingMode(.alwaysOriginal)
        )
    }
}
