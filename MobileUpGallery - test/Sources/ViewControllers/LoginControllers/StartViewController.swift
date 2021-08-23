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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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

        view.backgroundColor = .white
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(164 - 44)
        }

        vkLoginButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview().inset(50)
        }
    }

    private func setupNameLabel() {
        nameLabel.text = AppConfiguration.shared.appName
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 48, weight: .bold)
        nameLabel.insetsLayoutMarginsFromSafeArea = false
    }

    private func setupVKLoginButton() {
        vkLoginButton.backgroundColor = .black
        vkLoginButton.setTitleColor(.white, for: .normal)
        vkLoginButton.setTitle(R.string.localizable.sign_in_button_title(), for: .normal)
        vkLoginButton.layer.cornerRadius = 8
        vkLoginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        vkLoginButton.addTarget(self, action: #selector(openVKLoginController), for: .touchUpInside)
    }

}

// MARK: - Actions
extension StartViewController {
    @objc private func openVKLoginController() {
        let vc = UINavigationController(rootViewController: VKLoginWebViewController())
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }

}
