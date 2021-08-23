//
//  PhotoOpenViewController.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit

// MARK: - PhotoOpenViewController
final class PhotoOpenViewController: UIViewController {

    // MARK: - Properties
    private let imageView = UIImageView()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupConstraints()
    }
}

// MARK: - Methods
extension PhotoOpenViewController {
    func build(_ photo: Photo) {
        imageView.kf.setImage(with: URL(string: photo.pic))
        title = dateFormatter.string(from: photo.date)
    }
    
    private func setupViewController() {
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        view.backgroundColor = .white
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }

    }

    private func setupNavigationBar() {
        let rightBarButton = UIButton(type: .system)
        rightBarButton.setImage(UIImage(named: "share.button"), for: .normal)
        rightBarButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)

        let leftBarButton = UIButton(type: .system)
        leftBarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftBarButton.addTarget(self, action: #selector(backToPreviousScreen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.navigationBar.tintColor = .black
    }

}

// MARK: - Actions
extension PhotoOpenViewController {
    @objc private func backToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func shareButtonTapped() {
        guard let image = imageView.image else {
            AppContainer.showAlert(type: .failure, text: R.string.localizable.image_wrong())
            return
        }
        
        let shareController = UIActivityViewController(activityItems: [image],
                                                       applicationActivities: nil)
        
        shareController.completionWithItemsHandler = .some({ activityType, _, _, _ in
            guard let activityType = activityType else { return }
            switch activityType {
            case .saveToCameraRoll:
                AppContainer.showAlert(type: .success, text: R.string.localizable.image_saved())
            default:
                break
            }
        })
        
        present(shareController, animated: true)
    }

}
