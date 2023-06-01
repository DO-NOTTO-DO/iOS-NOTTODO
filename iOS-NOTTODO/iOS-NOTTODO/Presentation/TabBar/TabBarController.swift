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
        setTabBarItems()
        setTabBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabBarHeight()
    }
}

private extension TabBarController {
    func setTabBarItems() {
        tabs = [HomeViewController(),
                AchievementViewController(),
                MyInfoViewController()
        ]
        
        TabBarItemType.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.setTabBarItem()
            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
            tabs[$0.rawValue].tabBarItem.imageInsets = UIEdgeInsets.init(
                top: convertByHeightRatio(16),
                left: 0,
                bottom: convertByHeightRatio(-16),
                right: 0
            )
        }
        
        setViewControllers(tabs, animated: false)
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
