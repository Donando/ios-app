//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    enum Tab: String {
        case Search = "Search"
        case Info = "Info"
        
        static let AllTabs = [Search, Info]
    }
    
    
    override func viewDidLoad() {
        setupTabs()
        tabBar.barTintColor = UIColor.blackColor()
        
    }
    
    private func setupTabs() {
        var controllers = [UIViewController]()
        
        for (index, tab) in Tab.AllTabs.enumerate() {
            guard let tabNavigationController = rootNavigationViewController(forTab: tab) else { continue }
            
            let tabBarItem = UITabBarItem(title: tab.rawValue, image: UIImage(named: tab.rawValue + "TabIcon"), tag: index)
//            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            tabNavigationController.tabBarItem = tabBarItem
            
            controllers.append(tabNavigationController)
        }
        
        viewControllers = controllers
    }
    
    private func rootNavigationViewController(forTab tab: Tab) -> UIViewController? {
        return UIStoryboard(name: tab.rawValue, bundle: NSBundle.mainBundle()).instantiateInitialViewController()
    }
}

class TabBarNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.barTintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationBar.barStyle = .Black
    }
    
    
}
