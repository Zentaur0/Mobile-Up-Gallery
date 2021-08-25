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
        checkItemSize()
        setupViewController()
        setupConstraints()
        setupNavigationBar()
        loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.reloadData()
    }

}

// MARK: - Methods

extension GalleryViewController {
    
    private func setupViewController() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        guard let collectionView = collectionView else { return }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "background")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseID)

        view.addSubview(collectionView)
        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: "background")
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
        rightBarButtonItem.setTitle(R.string.appLoc.exit_button_title(), for: .normal)
        rightBarButtonItem.setTitleColor(.black, for: .normal)
        rightBarButtonItem.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        rightBarButtonItem.addTarget(self, action: #selector(exit), for: .touchUpInside)
        rightBarButtonItem.setTitleColor(UIColor(named: "text.color"), for: .normal)
        
        navigationController?.modalTransitionStyle = .partialCurl
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
        title = R.string.appLoc.self_title()
    }
    
    // MARK: - Load Photos
    
    private func loadPhotos() {
        networkManager?.loadPhotos(sender: nil) { [weak self] result in
            switch result {
            case .failure(let error):
                AppContainer.showAlert(type: .failure, text: error.localizedDescription)
            case .success(let photos):
                guard !photos.isEmpty else {
                    DispatchQueue.main.async {
                        AppConfiguration.removeData()
                        AppContainer.showAlert(type: .failure, text: R.string.alert.expired_token())
                    }
                    return
                }
                
                self?.chechPhotos(photos: photos)
                self?.photos = DataProvider.shared.photos
                
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
    
    private func chechPhotos(photos: [Photo]) {
        if DataProvider.shared.photos.count > photos.count {
            for photo in photos {
                if DataProvider.shared.photos.contains(photo) {
                    guard let index = DataProvider.shared.photos.firstIndex(of: photo) else { return }
                    DataProvider.shared.photos.remove(at: index)
                } else {
                    DataProvider.shared.photos.append(photo)
                }
            }
        } else {
            for photo in photos {
                if !DataProvider.shared.photos.contains(photo) {
                    DataProvider.shared.photos.append(photo)
                }
            }
        }
    }

    // MARK: - Item size check
    
    private func checkItemSize() {
        let screen = UIScreen.main.bounds
        if !orientationChecked {
            if screen.width < screen.height {
                portraitSize = CGSize(width: view.frame.width / 2 - 1, height: view.frame.width / 2 - 1)
                checkLandscape(by: true)
            } else {
                portraitSize = CGSize(width: view.frame.height / 2 - 1, height: view.frame.height / 2 - 1)
                checkLandscape(by: false)
            }
            orientationChecked = true
        }
    }

    private func checkLandscape(by width: Bool) {
        let screen = UIScreen.main.bounds
        let screenSize = screen.height > screen.width ? screen.height : screen.width
        let viewSize = width ? view.frame.width : view.frame.height
        
        switch true {
        // IPhone X, 11 Pro, 12 Mini, 12 Pro Max
        case screenSize == 926, screenSize == 812:
            landscapeSize = CGSize(width: (viewSize / 2) - 11, height: (viewSize / 2) - 11)
        // IPhone 11, 11 Pro Max
        case screenSize == 896:
            landscapeSize = CGSize(width: (viewSize / 2) - 8.5, height: (viewSize / 2) - 8.5)
        // IPhone 12, 12 Pro
        case screenSize == 844:
            landscapeSize = CGSize(width: (viewSize / 2) - 9.5, height: (viewSize / 2) - 9.5)
        // IPhone 8 Plus
        case screenSize == 736:
            landscapeSize = CGSize(width: (viewSize / 2) - 25, height: (viewSize / 2) - 25)
        // IPhone SE2, 8
        case screenSize == 667:
            landscapeSize = CGSize(width: (viewSize / 2) - 22.5, height: (viewSize / 2) - 22.5)
        // IPhone SE1
        case screenSize == 568:
            landscapeSize = CGSize(width: (viewSize / 2) - 19.5, height: (viewSize / 2) - 19.5)
        default:
            landscapeSize = CGSize(width: viewSize, height: viewSize)
        }
    }

}

// MARK: - Actions

extension GalleryViewController {
    
    @objc private func exit() {
        let alert = UIAlertController(title: R.string.alert.logout_text(), message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: R.string.alert.cancel_title(), style: .cancel, handler: nil)
        let exitAction = UIAlertAction(title: R.string.appLoc.exit_button_title(), style: .destructive) { _ in
            AppConfiguration.removeData()
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
        var photo = photos[indexPath.item]
        let vc = PhotoOpenViewController()
        let size = UIScreen.main.bounds.size
        
        vc.build(photo, size)
        vc.onPhotoLoad = { [weak self] in
            self?.photos.remove(at: indexPath.item)
            photo.makeLoaded()
            self?.photos.insert(photo, at: indexPath.item)
            DataProvider.shared.photos = self?.photos ?? []
        }
        
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
        case .portrait:                       return portraitSize
        case .landscapeLeft, .landscapeRight: return landscapeSize
        default:                              return portraitSize.width > landscapeSize.width ? portraitSize : landscapeSize
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
