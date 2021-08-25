//
//  ViewController.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit

// MARK: - StartViewController

final class StartViewController: UIViewController {

    // MARK: - Properties
    
    private let nameLabel: UILabel = UILabel()
    private let vkLoginButton: UIButton = UIButton(type: .system)
    private var labelSize: CGFloat?
    private var buttonSize: CGFloat?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSize()
        setupViewController()
        setupConstraints()
    }

}

// MARK: - Methods

extension StartViewController {
    
    private func setupViewController() {
        setupNameLabel()
        setupVKLoginButton()

        view.addSubview(nameLabel)
        view.addSubview(vkLoginButton)

        view.backgroundColor = UIColor(named: "background")
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(164 - 44)
        }

        vkLoginButton.snp.makeConstraints {
            $0.height.equalTo(buttonSize ?? 0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview().inset(50)
        }
    }

    private func setupNameLabel() {
        nameLabel.text = AppConfiguration.shared.appName
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: labelSize ?? 0, weight: .bold)
        nameLabel.insetsLayoutMarginsFromSafeArea = false
    }

    private func setupVKLoginButton() {
        vkLoginButton.backgroundColor = UIColor(named: "text.color")
        vkLoginButton.setTitleColor(UIColor(named: "background"), for: .normal)
        vkLoginButton.setTitle(R.string.appLoc.sign_in_button_title(), for: .normal)
        vkLoginButton.layer.cornerRadius = 8
        vkLoginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        vkLoginButton.addTarget(self, action: #selector(openVKLoginController), for: .touchUpInside)
    }
    
    private func checkSize() {
        let screen = UIScreen.main.bounds
        let biggestSize = screen.width > screen.height ? screen.width : screen.height
        
        if biggestSize < 600 {
            labelSize = 38
            buttonSize = 46
        } else {
            labelSize = 48
            buttonSize = 56
        }
    }

}

// MARK: - Actions

extension StartViewController {
    
    @objc private func openVKLoginController() {
        let networkManager = NetworkManager()
        let vc = UINavigationController(rootViewController: VKLoginWebViewController(networkManager: networkManager))
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }

}
