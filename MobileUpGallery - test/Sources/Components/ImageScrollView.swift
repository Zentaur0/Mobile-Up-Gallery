//
//  ImageScrollView.swift
//  MobileUpGallery - test
//
//  Created by Антон Сивцов on 24.08.2021.
//

import UIKit

// MARK: - ImageScrollView

final class ImageScrollView: UIScrollView {

     // MARK: - Properties
    
    var zoomImageView: UIImageView = UIImageView()
    private var isMinimumZoomScaleSet = false
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        tap.numberOfTapsRequired = 2
        return tap
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
        setCurrentMaxAndMinZoomScale()
        if !isMinimumZoomScaleSet {
            zoomScale = minimumZoomScale
            isMinimumZoomScaleSet = true
        }
    }
    
}

// MARK: - Methods

extension ImageScrollView {
    
    private func setupView() {
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(zoomingTap)

        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        addSubview(zoomImageView)
    }

    private func setupConstraints() {
        zoomImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setCurrentMaxAndMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = zoomImageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        
        if minScale < 0.1 {
            maxScale = 0.3
        }
        
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }

    private func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = zoomImageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        zoomImageView.frame = frameToCenter
    }

    private func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }

}

// MARK: - Actions
extension ImageScrollView {
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }

}

// MARK: - UIScrollViewDelegate
extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.zoomImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
    
}
