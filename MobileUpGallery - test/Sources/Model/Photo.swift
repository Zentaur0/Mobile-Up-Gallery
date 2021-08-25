//
//  Photo.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 22.08.2021.
//

import UIKit
import SwiftyJSON

// MARK: - Photo

struct Photo: Codable {
    
    /// Photo self url
    var pic: String
    /// VK photo load date
    var date: Date
    /// check if photo was loaded on device 
    var isLoaded = false
    
    mutating func makeLoaded() {
        self.isLoaded = true
    }

    // MARK: - Init
    
    init(json: SwiftyJSON.JSON) {
        let size = json["sizes"].arrayValue.last
        self.pic = size?["url"].stringValue ?? ""
        self.date = Date(timeIntervalSince1970: json["date"].doubleValue)
    }
    
}

// MARK: - Equatable

extension Photo: Equatable {
    
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.date == rhs.date && lhs.pic == rhs.pic
    }
    
}
