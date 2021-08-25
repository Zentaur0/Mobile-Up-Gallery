//
//  UIAplication + Extensions.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 23.08.2021.
//

import UIKit

// MARK: - UIApplication: TopViewController

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = AppDelegate.shared.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
