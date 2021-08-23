//
//  URLs.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 20.08.2021.
//

import UIKit

final class URLs {
    
    // MARK: - Static
    static let authorizationURL = "https://oauth.vk.com/authorize?client_id=\(AppConfiguration.shared.vkAppID)&redirect_uri=\(AppConfiguration.shared.vkRedirectUri).html&display=mobile&scope=262150&response_type=token&state=succeded"
    
    static let albumURL = "https://api.vk.com/method/photos.get?access_token=\(AppConfiguration.shared.vkToken)&owner_id=\(AppConfiguration.shared.vkGroupID)&album_id=\(AppConfiguration.shared.vkAlbumID)&rev=0&v=5.131"
}
