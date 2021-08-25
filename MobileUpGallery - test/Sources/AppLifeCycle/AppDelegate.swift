//
//  AppDelegate.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit
import SnapKit

typealias EmptyClosure = (() -> Void)

// MARK: - AppDelegate
@main
class AppDelegate: UIResponder {
    
    // MARK: - Static
    static let shared = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Properteis
    var window: UIWindow?
    
}

// MARK: - Methods
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppContainer.checkTokenExpirationDate()
        
        let rootController = AppContainer.makeRootController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = rootController

        return true
    }
    
}
