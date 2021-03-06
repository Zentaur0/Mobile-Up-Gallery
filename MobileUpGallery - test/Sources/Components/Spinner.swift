//
//  Spinner.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 23.08.2021.
//

import UIKit

// MARK: - Spinner

final class Spinner: UIViewController {
    
    // MARK: - Properties
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinner()
    }
    
}

// MARK: - Methods

extension Spinner {
    
    private func setupSpinner() {
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        spinner.color = .white
        
        view.addSubview(spinner)
        
        spinner.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        spinner.startAnimating()
    }
    
}
