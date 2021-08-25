//
//  AppConfiguration.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 20.08.2021.
//

import UIKit
import KeychainSwift
import WebKit

// MARK: - VKKeychainKeys

enum VKKeychainKeys: String {
    case vkTokenKey = "vkTokenKey"
}

// MARK: - AppConfiguration

final class AppConfiguration {
    
    // MARK: - Static
    
    static let shared = AppConfiguration()
    
    // MARK: - Properties
    
    // MARK: Internal
    /// Name of the App
    let appName = """
        Mobile Up
        Gallery
        """
    /// app id
    let vkAppID = "7930517"
    /// user id
    let vkRedirectUri = "https://oauth.vk.com/blank"
    /// vk group id
    let vkGroupID = "-128666765"
    /// vk album id
    let vkAlbumID = "266276915"
    /// secret
    let vkSecret = "JsxmH9UWm3VQo9oTjq2y"
    /// vk app token
    let vkAppToken = "afd6f0deafd6f0deaf98747de7afaff24baafd6afd6f0decef2ebaf7c73c51f983dfb68"
    /// vk token
    var vkToken: String {
        keychain.get(VKKeychainKeys.vkTokenKey.rawValue) ?? ""
    }
    
    // MARK: - Private
    
    private let keychain = KeychainSwift()
    
    // MARK: - Init
    
    private init() {}
}

// MARK: - Methods

extension AppConfiguration {
    
    static func addToKeychain(value: String, key: VKKeychainKeys) {
        AppConfiguration.shared.keychain.set(value, forKey: key.rawValue)
    }
    
    static func removeFromKeychain(key: VKKeychainKeys) {
        AppConfiguration.shared.keychain.delete(key.rawValue)
    }
    
    static func removeData() {
        AppConfiguration.removeFromKeychain(key: .vkTokenKey)
        UserDefaults.standard.setValue(false, forKey: "isAuthorized")
        DataProvider.shared.photos = []
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records.filter { $0.displayName.contains("vk")}) {
                AppContainer.createSpinnerView(UIApplication.topViewController()?.navigationController ?? UIViewController(),
                                               AppContainer.makeRootController())
            }
        }
    }
    
}
