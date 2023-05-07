//
//  ImageCache.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: NSURL) -> UIImage? {
        return cache.object(forKey: url)
    }

    func insertImage(_ image: UIImage?, for url: NSURL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url)
    }
}
