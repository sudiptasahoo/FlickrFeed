//
//  EasyCache.swift
//  ImageCache
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

struct EasyCache {
    
    var cache: URLCache
    
    static let shared = EasyCache()
    
    init(cache: URLCache = .shared) {
        self.cache = cache
    }
    
    func addImage(cacheData: CachedURLResponse, key: URLRequest) {
        self.cache.storeCachedResponse(cacheData, for: key)
    }
    
    func getImage(key: URLRequest) -> UIImage? {
        if let data = self.cache.cachedResponse(for: key)?.data, let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func invalidateAllCache() {
        cache.removeAllCachedResponses()
    }
    
    func invalidateCache(for imageUrl: URL) {
        cache.removeCachedResponse(for: URLRequest(url: imageUrl))
    }
}
