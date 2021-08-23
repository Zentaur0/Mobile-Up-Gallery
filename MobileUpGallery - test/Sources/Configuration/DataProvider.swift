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
    var photos: [Photo] = []
    
    // MARK: - Init
    private init() {}
}
