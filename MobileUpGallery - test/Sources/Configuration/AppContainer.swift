//
//  AppContainer.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit
import SwiftyJSON

// MARK: - AppContainer

final class AppContainer {

    // MARK: - Init
    
    private init() {}
    
    // MARK: - UserTokenExpirationDatecheck
    
    /// Checking if vk user token has been expired
    static func checkTokenExpirationDate() {
        let urlString = URLs.checkTokenURL
        let currentDate = Date()
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            do {
                guard let data = data else { return }
                let json = try JSON(data: data)
                let dateJson = json["response"]["expire"].intValue
                let expirationDate = Date(timeIntervalSince1970: TimeInterval(dateJson))
                let distance = expirationDate.distance(to: currentDate)
                
                if distance >= 0 && !AppConfiguration.shared.vkToken.isEmpty {
                    DispatchQueue.main.async {
                        AppConfiguration.removeData()
                        AppContainer.createSpinnerView(UIApplication.topViewController()?.navigationController ?? UINavigationController(),
                                                       AppContainer.makeRootController())
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
                            AppContainer.showAlert(type: .failure, text: R.string.alert.expired_token())
                        }
                    }
                }
            } catch {
                AppContainer.showAlert(type: .failure, text: error.localizedDescription)
            }
        }.resume()
    }

    // MARK: - RootController
    
    /// Making Root View Controller
    static func makeRootController() -> UIViewController {
        let isAuthorized = AppConfiguration.shared.vkToken
        
        let networkManager = NetworkManager()
        let galleryVC = UINavigationController(rootViewController: GalleryViewController(networkManager: networkManager))
        let startVC = StartViewController()

        return isAuthorized.isEmpty ? startVC : galleryVC
    }
    
    // MARK: - SpinnerViewController
    
    static func createSpinnerView(_ onViewController: UIViewController,
                                  _ showViewController: UIViewController) {
        let child = Spinner()
        
        onViewController.addChild(child)
        child.view.frame = onViewController.view.bounds
        onViewController.view.addSubview(child.view)
        child.didMove(toParent: onViewController.self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            AppDelegate.shared.window?.rootViewController = showViewController
        }
        
    }
    
    // MARK: - Show Alert
    
    /// Show custom alert with types: .success, .failure or .default
    static func showAlert(type: AlertType, text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let alert = CustomAlertView(text: text, type: type)
        appDelegate.window?.addSubview(alert)
        animateAlert(alert: alert)
    }
    
    // MARK: - Alert Animation
    
    private static func animateAlert(alert: UIView) {
        
        alert.frame = CGRect(x: alert.frame.minX,
                             y: alert.frame.minY,
                             width: UIScreen.main.bounds.width,
                             height: -130)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            alert.frame = CGRect(x: alert.frame.minX,
                                 y: alert.frame.maxY,
                                 width: UIScreen.main.bounds.width,
                                 height: 130)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.1) {
                alert.frame = CGRect(x: alert.frame.minX,
                                     y: alert.frame.minY,
                                     width: UIScreen.main.bounds.width,
                                     height: -130)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                alert.removeFromSuperview()
            }
        }
    }

}
