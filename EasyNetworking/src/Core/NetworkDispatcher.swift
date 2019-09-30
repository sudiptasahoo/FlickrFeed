//
//  NetworkDispatcher.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public protocol NetworkDispatchable {
    
    var session: URLSession { get }
    
    /**
     This method dispatches HTTP request using URLSession
     - parameter request: This is the prepared URLRequest to be dispatched finally
     */
    func dispatchRequest(_ request: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionDataTask
}


public struct NetworkDispatcher: NetworkDispatchable{
    
    public var session: URLSession
    
    init(sessionConfiguration: URLSessionConfiguration = NetworkDispatcher.defaultSessionConfiguration()) {
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    
    public func dispatchRequest(_ request: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            completion(data, urlResponse as? HTTPURLResponse, error)
        }
        
        task.resume()
        return task
    }
    
}

extension NetworkDispatcher {
    
    public static func defaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = NetworkDispatcher.additionalHeaders()
        if #available(iOS 11.0, tvOS 11.0, *) {
            configuration.waitsForConnectivity = true
        }
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return configuration
    }
    
    public static func additionalHeaders() ->  [AnyHashable: Any]? {
        return [
            "Accept": "application/json",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "en-us",
            "CONNECTION": "keep-alive"
        ]
    }
}
