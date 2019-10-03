//
//  EasyImage.swift
//  ImageCache
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

public enum ImageFetchSource{
    case cache
    case online
}

typealias FetchImageCompletion =  (_ url: URL, _ image:  UIImage?, _ source: ImageFetchSource) -> Void

public final class EasyImage {
        
    lazy var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.sudipta.async.image.downloadQueue"
        queue.maxConcurrentOperationCount = 50
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    public static let shared = EasyImage()
    private var cache: EasyCache
    
    private init(cache: EasyCache = .shared) {
        self.cache = cache
    }
    
    func downloadImage(withURL imageURL: URL, completion: @escaping FetchImageCompletion) {
        
        if let image = self.cache.getImage(key: URLRequest(url: imageURL)) {
            completion(imageURL, image, .cache)
        } else if let existingImageOperations = downloadQueue.operations as? [ImageOperation],
            let imgOperation = existingImageOperations.first(where: {
                return ($0.imageURL == imageURL) && $0.isExecuting && !$0.isFinished
            }) {
            imgOperation.queuePriority = .veryHigh
        } else {
            let imageOperation = ImageOperation(imageURL: imageURL, completion: completion)
            imageOperation.queuePriority = .veryHigh
            downloadQueue.addOperation(imageOperation)
        }
    }
    
    public func changeDownloadPriority(for imageURL: URL, priority: Operation.QueuePriority = .veryLow) {
        guard let ongoingImageOperations = downloadQueue.operations as? [ImageOperation] else {
            return
        }
        let imageOperations = ongoingImageOperations.filter {
            $0.imageURL.absoluteString == imageURL.absoluteString && !$0.isFinished
        }
        guard let operation = imageOperations.first else {
            return
        }
        operation.queuePriority = priority
    }
    
    public func cancelAll() {
        downloadQueue.cancelAllOperations()
    }
    
    public func cancelOperation(for imageUrl: URL) {
        if let imageOperations = downloadQueue.operations as? [ImageOperation],
            let operation = imageOperations.first(where: { $0.imageURL == imageUrl }) {
            operation.cancel()
        }
    }
    
    public func clearAllCache() {
        cache.invalidateAllCache()
    }
    
    public func clearCache(for imageUrl: URL) {
        cache.invalidateCache(for: imageUrl)
    }
}
