//
//  AppConfiguration.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 20.08.2021.
//

import UIKit
import KeychainSwift

enum KeychainKeys: String {
    case vkTokenKey = "vkTokenKey"
}

// MARK: - AppConfiguration
final class AppConfiguration {
    
    // MARK: - Static
    static let shared = AppConfiguration()
    
    // MARK: - Properties
    // MARK: - Internal
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
    /// vk token
    var vkToken: String {
        keychain.get(KeychainKeys.vkTokenKey.rawValue) ?? ""
    }
    
    // MARK: - Private
    private let keychain = KeychainSwift()
    
    // MARK: - Init
    private init() {}
}

// MARK: - Methods
extension AppConfiguration {
    static func addToKeychain(value: String, key: KeychainKeys) {
        AppConfiguration.shared.keychain.set(value, forKey: key.rawValue)
    }
    
    static func removeFromKeychain(key: KeychainKeys) {
        AppConfiguration.shared.keychain.delete(key.rawValue)
    }
    
}
