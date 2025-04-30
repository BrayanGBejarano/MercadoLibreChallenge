//
//  ImageCarouselView.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit
import Kingfisher

final class ImageCarouselView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .mlPrimary
        pc.pageIndicatorTintColor = .systemGray4
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private var imageViews: [UIImageView] = []
    private var currentPage: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(scrollView)
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(with imageUrls: [URL], placeholder: UIImage? = nil) {
        clearImages()
        pageControl.numberOfPages = imageUrls.count
        pageControl.currentPage = 0
        
        var previousImageView: UIImageView?
        
        for (index, url) in imageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [
                    .transition(.fade(0.3)),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]
            )
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: widthAnchor),
                imageView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
            
            if let previous = previousImageView {
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }
            
            if index == imageUrls.count - 1 {
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            }
            
            previousImageView = imageView
        }
    }
    
    func updateLayoutForRotation() {
        guard !imageViews.isEmpty else { return }
        
        let offset = CGFloat(currentPage) * frame.width
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
    }
    
    private func clearImages() {
        imageViews.forEach {
            $0.kf.cancelDownloadTask()
            $0.removeFromSuperview()
        }
        imageViews.removeAll()
    }
}

extension ImageCarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        currentPage = Int(pageIndex)
        pageControl.currentPage = currentPage
    }
}
