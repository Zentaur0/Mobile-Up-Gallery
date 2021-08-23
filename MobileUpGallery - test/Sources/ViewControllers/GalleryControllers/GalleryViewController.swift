//
//  GalleryViewController.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit
import SwiftyJSON

// MARK: - GalleryViewController
final class GalleryViewController: UIViewController {

    // MARK: - Properties
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView?
    private var portraitSize: CGSize?
    private var landscapeSize: CGSize?
    private var orientationChecked = false
    private var selectedCell: GalleryCollectionViewCell?
    private var photos: [Photo] = DataProvider.shared.photos

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkItemSize()
        setupViewController()
        setupConstraints()
        setupNavigationBar()
        
        NetworkManager.shared.loadPhotos { result in
            switch result {
            case .failure(let error):
                AppContainer.showAlert(type: .failure, text: error.localizedDescription)
            case .success(let photos):
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
        print(AppConfiguration.shared.vkToken)
        let url = "https://api.vk.com/method/secure.checkToken?token=\(AppConfiguration.shared.vkToken)"
//        https://api.vk.com/method/secure.checkToken?token=223c641e4e4be40b9131e1adb90bf81bc43b10f4b0761c2cc9ff5955f4c2f86aaa36042096081d441f066
        
//        JsxmH9UWm3VQo9oTjq2y
//        53e34ce953e34ce953e34ce9a0539a4e7c553e353e34ce932fd1de89549517437d2da21
//        guard let url = URL(string: url) else { return }
//
//        let session = URLSession.shared
//        session.dataTask(with: url) { data, response, error in
//            do {
//                if let data = data {
//                    let json = try JSON(data: data)
//                    print(json)
//                }
//            } catch {
//                print(error)
//            }
//        }.resume()
    }

}

// MARK: - Methods
extension GalleryViewController {
    private func setupViewController() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        guard let collectionView = collectionView else { return }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseID)

        view.addSubview(collectionView)
        view.backgroundColor = .white
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .partialCurl
    }

    private func setupConstraints() {
        guard let collectionView = collectionView else { return }

        collectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        let rightBarButtonItem = UIButton(type: .system)
        rightBarButtonItem.setTitle(R.string.localizable.exit_button_title(), for: .normal)
        rightBarButtonItem.setTitleColor(.black, for: .normal)
        rightBarButtonItem.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        rightBarButtonItem.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        navigationController?.modalTransitionStyle = .partialCurl
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
        title = R.string.localizable.self_title()
    }

    private func checkItemSize() {
        let screen = UIScreen.main.bounds
        if !orientationChecked {
            if screen.width < screen.height {
                portraitSize = CGSize(width: view.frame.width / 2 - 1, height: view.frame.width / 2 - 1)
                checkLandscape(screen: screen, by: true)
            } else {
                portraitSize = CGSize(width: view.frame.height / 2 - 1, height: view.frame.height / 2 - 1)
                checkLandscape(screen: screen, by: false)
            }
            orientationChecked = true
        }
    }

    private func checkLandscape(screen: CGRect, by width: Bool) {
        switch true {
        case screen.height > 750:
            if width {
                landscapeSize = CGSize(width: (view.frame.width / 2) - 8, height: (view.frame.width / 2) - 8)
            } else {
                landscapeSize = CGSize(width: (view.frame.height / 2) - 8, height: (view.frame.height / 2) - 8)
            }
        case screen.height < 750 && screen.height > 700:
            if width {
                landscapeSize = CGSize(width: (view.frame.width / 2) - 25, height: (view.frame.width / 2) - 25)
            } else {
                landscapeSize = CGSize(width: (view.frame.height / 2) - 25, height: (view.frame.height / 2) - 25)
            }
        case screen.height < 700:
            if width {
                landscapeSize = CGSize(width: (view.frame.width / 2) - 26, height: (view.frame.width / 2) - 26)
            } else {
                landscapeSize = CGSize(width: (view.frame.height / 2) - 26.5, height: (view.frame.height / 2) - 26.5)
            }
        default:
            break
        }
    }

}

// MARK: - Actions
extension GalleryViewController {
    @objc private func exit() {
        let alert = UIAlertController(title: R.string.localizable.logout_text(), message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.localizable.exit_title(), style: .cancel, handler: nil)
        let exitAction = UIAlertAction(title: R.string.localizable.exit_button_title(), style: .destructive) { _ in 
            AppConfiguration.removeFromKeychain(key: .vkTokenKey)
            UserDefaults.standard.setValue(false, forKey: "isAuthorized")
            
            AppContainer.createSpinnerView(self.navigationController ?? UINavigationController(), AppContainer.makeRootController())
        }
        alert.addAction(cancelAction)
        alert.addAction(exitAction)
        
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseID,
                                                            for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.build(photos: photos, indexPath: indexPath)

        return cell
    }

}

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let vc = PhotoOpenViewController()
        vc.build(photo)
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let portraitSize = portraitSize,
              let landscapeSize = landscapeSize else { return CGSize() }
        
        switch UIDevice.current.orientation {
        case .portrait: return portraitSize
        case .landscapeLeft, .landscapeRight: return landscapeSize
        default: return portraitSize.width > landscapeSize.width ? portraitSize : landscapeSize
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        2
    }

}
