//
//  PhotoOpenViewController.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit
import Photos

// MARK: - PhotoOpenViewController

final class PhotoOpenViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: Internal
    
    var onPhotoLoad: EmptyClosure?
    
    // MARK: Private
    
    private let imageScrollView: ImageScrollView = ImageScrollView()
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
    
    func build(_ photo: Photo, _ size: CGSize) {
        imageScrollView.zoomImageView.kf.setImage(with: URL(string: photo.pic))
        title = dateFormatter.string(from: photo.date)
    }
    
    private func setupViewController() {
        view.addSubview(imageScrollView)
        view.backgroundColor = UIColor(named: "background")
    }

    private func setupConstraints() {
        imageScrollView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupNavigationBar() {
        let rightBarButton = UIButton(type: .system)
        rightBarButton.setImage(R.image.shareButton(), for: .normal)
        rightBarButton.tintColor = UIColor(named: "text.color")
        rightBarButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)

        let leftBarButton = UIButton(type: .system)
        leftBarButton.tintColor = UIColor(named: "text.color")
        leftBarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftBarButton.addTarget(self, action: #selector(backToPreviousScreen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        createSeparator()
    }
    
    private func createSeparator() {
        let separator = UIView()
        separator.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.addSubview(separator)
        
        separator.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(0.5)
        }
    }

}

// MARK: - Actions

extension PhotoOpenViewController {
    
    @objc private func backToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func shareButtonTapped() {
        guard let image = imageScrollView.zoomImageView.image else {
            AppContainer.showAlert(type: .failure, text: R.string.alert.image_wrong())
            return
        }
        
        let shareController = UIActivityViewController(activityItems: [image],
                                                       applicationActivities: nil)
        
        shareController.completionWithItemsHandler = .some { [weak self] activityType, _, _, _ in
            guard let activityType = activityType else { return }
            switch activityType {
            case .saveToCameraRoll:
                let authorizationStatus = PHPhotoLibrary.authorizationStatus()
                switch authorizationStatus {
                case .authorized:
                    AppContainer.showAlert(type: .success, text: R.string.alert.image_saved())
                    self?.onPhotoLoad?()
                case .limited:
                    AppContainer.showAlert(type: .success, text: R.string.alert.image_saved())
                    self?.onPhotoLoad?()
                case .notDetermined:
                    break
                case .restricted:
                    AppContainer.showAlert(type: .failure, text: R.string.alert.image_wrong())
                case .denied:
                    AppContainer.showAlert(type: .failure, text: R.string.alert.image_wrong())
                @unknown default:
                    AppContainer.showAlert(type: .failure, text: R.string.alert.unexpected_error())
                }
            default:
                break
            }
        }
        
        present(shareController, animated: true)
    }

}
