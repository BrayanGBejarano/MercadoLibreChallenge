//
//  UIImageView+Loading.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 24/04/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(
        from url: URL?,
        placeholder: UIImage? = nil,
        options: KingfisherOptionsInfo? = nil,
        completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        let defaultOptions: KingfisherOptionsInfo = [
            .transition(.fade(0.3)),
            .cacheOriginalImage,
            .targetCache(KingfisherManager.shared.cache)
        ]
        
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options ?? defaultOptions,
            completionHandler: { result in
                switch result {
                case .success(let value):
                    completion?(.success(value.image))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        )
    }
    
    static func clearImageCache(completion: (() -> Void)? = nil) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache(completion: completion)
    }
}
