//
//  ImageOperation.swift
//  ImageCache
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

final class ImageOperation: Operation {
    
    var imageDownloadCompletionHandler: FetchImageCompletion
    
    public let imageURL: URL
    private var downloadTask: URLSessionDataTask?
    private var cache: EasyCache
    
    init(imageURL: URL, completion: @escaping FetchImageCompletion, cache: EasyCache = .shared) {
        self.imageURL = imageURL
        self.imageDownloadCompletionHandler = completion
        self.cache = cache
    }
    
    private enum OperationState: String, Equatable {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var _state = OperationState.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: _state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: _state.rawValue)
        }
    }
    
    private var state: OperationState {
        get {
            return _state
        }
        set {
            _state = newValue
        }
    }
    
    // MARK: - Various `Operation` properties
    
    override var isReady: Bool {
        return state == .ready && super.isReady
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    
    // MARK: - Start
    
    override func start() {
        if isCancelled {
            finish()
            return
        }
        
        if !isExecuting {
            state = .executing
        }
        
        main()
    }
    
    // MARK: - Finish
    
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    // MARK: - Cancel
    
    override func cancel() {
        downloadTask?.cancel()
        finish()
        super.cancel()
    }
    
    //MARK: - Main
    override func main() {
        downloadImage()
    }
    
    private func downloadImage() {
        
        let request = URLRequest(url: self.imageURL)
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let self = self else { return }
            self.downloadTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.cache.addImage(cacheData: cachedData, key: request)
                    self.imageDownloadCompletionHandler(self.imageURL, image, .online)
                } else{
                    self.imageDownloadCompletionHandler(self.imageURL, nil, .cache)
                }
                self.finish()
            })
            self.downloadTask?.resume()
        }
    }
}

