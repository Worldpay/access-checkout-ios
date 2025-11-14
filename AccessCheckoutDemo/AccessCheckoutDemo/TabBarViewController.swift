import UIKit

class TabBarViewController: UITabBarController {
    private let tabBarId = "tabBar"
    private let tabBarItemId = "tabBarItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.accessibilityIdentifier = tabBarId
        tabBar.items?.enumerated().forEach { (index, item) in
            item.accessibilityIdentifier = "\(tabBarItemId)_\(index)"
        }
    }
    
}
