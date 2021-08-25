//
//  GalleryCollectionViewCell.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 18.08.2021.
//

import UIKit
import Kingfisher

// MARK: - GalleryCollectionViewCell

final class GalleryCollectionViewCell: UICollectionViewCell {

    // MARK: - Static
    
    static let reuseID: String = "GalleryCollectionViewCell"

    // MARK: - Properties
    
    private let imageView: UIImageView = UIImageView()
    private let loadedSingImageView: UIImageView = UIImageView()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Methods

extension GalleryCollectionViewCell {
    
    func build(photos: [Photo], indexPath: IndexPath) {
        imageView.kf.setImage(with: URL(string: photos[indexPath.item].pic))
        loadedSingImageView.isHidden = photos[indexPath.row].isLoaded ? false : true
    }

    private func setupCell() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        loadedSingImageView.tintColor = .white
        loadedSingImageView.image = R.image.imageLoaded()

        contentView.addSubview(imageView)
        imageView.addSubview(loadedSingImageView)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadedSingImageView.snp.makeConstraints {
            $0.height.width.equalTo(25)
            $0.bottom.trailing.equalToSuperview().inset(5)
        }
    }

}
