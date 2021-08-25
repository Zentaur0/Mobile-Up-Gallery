//
//  DataProvider.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 23.08.2021.
//

import UIKit

// MARK: - DataProvider

final class DataProvider {
    
    // MARK: - Static
    
    static let shared = DataProvider()
    
    // MARK: - Properties
    
    var photos: [Photo] {
        get {
            guard let data = try? Data(contentsOf: .vkPhotos) else { return [] }
            return (try? JSONDecoder().decode([Photo].self, from: data)) ?? []
        }
        set {
            try? JSONEncoder().encode(newValue).write(to: .vkPhotos)
        }
    }
    
    // MARK: - Init
    
    private init() {}
}
