//
//  NetworkManager.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 19.08.2021.
//

import UIKit
import SwiftyJSON

// MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol: AnyObject {
    func loadPhotos(sender: UIViewController?, completion: @escaping (Result<[Photo], Error>) -> Void)
}

// MARK: - NetworkManager

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Load Photos
    
    func loadPhotos(sender: UIViewController? = nil, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let urlString = URLs.albumURL
        
        guard let url = URL(string: urlString) else { return }
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.waitsForConnectivity = true
        sessionConfiguration.timeoutIntervalForRequest = 300

        let session = URLSession(configuration: sessionConfiguration)
        
        session.dataTask(with: url) { data, response, error in
            guard let _ = response else {
                AppContainer.showAlert(type: .failure, text: R.string.alert.no_response())
                return
            }
            
            do {
                guard let data = data else {
                    AppContainer.showAlert(type: .failure, text: R.string.alert.wrong_data())
                    return
                }

                let json = try JSON(data: data)
                let friendJSON = json["response"]["items"].arrayValue
                let friend = friendJSON.map { Photo(json: $0) }

                UserDefaults.standard.set(true, forKey: "isAuthorized")
                
                completion(.success(friend))
                
                if let sender = sender {
                    DispatchQueue.main.async {
                        sender.dismiss(animated: true) {
                            AppContainer.createSpinnerView(UIApplication.topViewController() ?? UIViewController(),
                                                           AppContainer.makeRootController())
                        }
                    }
                }
            } catch {
                AppContainer.showAlert(type: .failure, text: error.localizedDescription)
                UserDefaults.standard.set(false, forKey: "isAuthorized")
                completion(.failure(error))
                DispatchQueue.main.async {
                    sender?.dismiss(animated: true) {
                        AppContainer.createSpinnerView(UIApplication.topViewController() ?? UIViewController(),
                                                       AppContainer.makeRootController())
                    }
                }
                
            }
        }.resume()
    }
    
}
