//
//  FetchImage.swift
//  ImageCache
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

typealias FetchImageCompletion =  (_ image:  UIImage?, _ source: ImageFetchSource) -> Void

enum ImageFetchSource{
    case cache
    case online
}

protocol ImageFetchable{
    var cache: URLCache {get}
    func fetchImage(from url: URL, completion: @escaping FetchImageCompletion)
}

struct FetchImage: ImageFetchable{
    
    var cache: URLCache
    
    init(cache: URLCache){
        self.cache = cache
    }
    
    func fetchImage(from url: URL, completion: @escaping FetchImageCompletion) {
        
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion(image, .cache)
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedData, for: request)
                    completion(image, .online)
                } else{
                    completion(nil, .online)
                }
            }).resume()
        }
    }
    
}
