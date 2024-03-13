//
//  TabBarController.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 2023/02/17.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private var tabs: [UIViewController] = []
    private lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabBarHeight()
    }
}

extension TabBarController {
    
    func setTabBarItems() -> [UITabBarItem] {
        let tabBarItems = TabBarItemType.allCases.map {
            let tabBarItem = $0.setTabBarItem()
            tabBarItem.tag = $0.rawValue
            tabBarItem.imageInsets = UIEdgeInsets(top: convertByHeightRatio(16),
                                                  left: 0,
                                                  bottom: convertByHeightRatio(-16),
                                                  right: 0)
            return tabBarItem
        }
        return tabBarItems
    }
    
    func setTabBarUI() {
        tabBar.setUpUITabBar()
        tabBar.backgroundColor = .gray1
        tabBar.layer.cornerRadius = convertByHeightRatio(15)
        tabBar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        tabBar.itemPositioning = .centered
    }
    
    func setTabBarHeight() {
        let newTabBarHeight = defaultTabBarHeight + convertByHeightRatio(7)
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
}
