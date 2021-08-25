//
//  VKWebViewController.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit
import WebKit

// MARK: - VKLoginWebViewController

final class VKLoginWebViewController: UIViewController {

    // MARK: - Properties
    
    private let webView: WKWebView = WKWebView()
    private var networkManager: NetworkManagerProtocol?
    
    // MARK: - Init
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupConstraints()
        loadRequest()
    }

}

// MARK: - Methods

extension VKLoginWebViewController {
    
    
    // MARK: - Setup
    
    private func setupViewController() {
        webView.navigationDelegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(closeLoginScreen))

        view.backgroundColor = UIColor(named: "background")
        view.addSubview(webView)
    }

    private func setupConstraints() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func loadPhotos() {
        networkManager?.loadPhotos(sender: self) { result in
            switch result {
            case .failure(let error):
                AppContainer.showAlert(type: .failure, text: error.localizedDescription)
            case .success(let photos):
                DataProvider.shared.photos = photos
            }
        }
    }
    
    // MARK: - Request
    
    private func loadRequest() {
        let urlString = URLs.authorizationURL
        
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func getParameters(fragments: String) -> [String : String] {
        let parameters = fragments.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, parameters in
                var dictionary = result
                let key = parameters[0]
                let value = parameters[1]
                dictionary[key] = value
                return dictionary
            }
        
        return parameters
    }
    
}

// MARK: - Actions

extension VKLoginWebViewController {
    
    @objc private func closeLoginScreen() {
        dismiss(animated: true) {
            AppContainer.showAlert(type: .default, text: "Operation canceled")
        }
    }

}

// MARK: - WKNavigationDelegate

extension VKLoginWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let framgents = url.fragment else {
            
            decisionHandler(.allow)
            return
        }

        let parameters = getParameters(fragments: framgents)

        guard let token = parameters["access_token"],
              !token.isEmpty else {
            
            AppContainer.showAlert(type: .failure, text: "Permission denied")
            dismiss(animated: true, completion: nil)
            decisionHandler(.allow)
            return
        }
        
        AppConfiguration.addToKeychain(value: token, key: .vkTokenKey)
        AppContainer.showAlert(type: .success, text: R.string.alert.successful_authorization())
        
        loadPhotos()

        decisionHandler(.cancel)
    }

}

