//
//  URLs.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 20.08.2021.
//

import UIKit

// MARK: - URLs

final class URLs {
    
    // MARK: - Static
    
    static let authorizationURL = "https://oauth.vk.com/authorize?client_id=\(AppConfiguration.shared.vkAppID)&redirect_uri=\(AppConfiguration.shared.vkRedirectUri).html&display=mobile&response_type=token&state=succeded&revoke=1"
    
    static let albumURL = "https://api.vk.com/method/photos.get?access_token=\(AppConfiguration.shared.vkToken)&owner_id=\(AppConfiguration.shared.vkGroupID)&album_id=\(AppConfiguration.shared.vkAlbumID)&rev=0&v=5.131"
    
    static let checkTokenURL = "https://api.vk.com/method/secure.checkToken?token=\(AppConfiguration.shared.vkToken)&access_token=\(AppConfiguration.shared.vkAppToken)&client_secret=\(AppConfiguration.shared.vkSecret)&v=5.131"
    
}
