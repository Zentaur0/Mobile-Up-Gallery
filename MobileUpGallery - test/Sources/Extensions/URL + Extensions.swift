//
//  URL + Extensions.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 25.08.2021.
//

import Foundation

// MARK: - URL

extension URL {
    
    static var vkPhotos: URL {
        let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let bundleID = Bundle.main.bundleIdentifier ?? "svtsv"
        let subDirectory = applicationSupport?.appendingPathComponent(bundleID, isDirectory: true)
        
        try? FileManager.default.createDirectory(at: subDirectory ?? URL(fileURLWithPath: ""),
                                                 withIntermediateDirectories: true, attributes: nil)
        
        return subDirectory?.appendingPathComponent("photos.json") ?? URL(fileURLWithPath: "")
    }
    
}
