//
//  MockNetworking.swift
//  EasyNetworkingTests
//
//  Created by Sudipta Sahoo on 03/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
@testable import EasyNetworking

final class MockSuccessDispatcher: NetworkDispatchable {
    
    var session: URLSession
    
    var receivedResponseHandler: ((_ request: URLRequest) -> Void)?
    
    init(sessionConfiguration: URLSessionConfiguration = NetworkDispatcher.defaultSessionConfiguration()) {
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func dispatchRequest(_ request: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionDataTask {
        
        let successUrlResponse = HTTPURLResponse(url: URL(string: "https://apple.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
        
        completion(MockContact.shared.contactData, successUrlResponse, nil)
        receivedResponseHandler?(request)
        return session.dataTask(with: request)
    }
}


final class MockFailureDispatcher: NetworkDispatchable {
    
    var session: URLSession
    var errorCode: Int = 400
    
    var receivedResponseHandler: ((_ request: URLRequest) -> Void)?
    
    init(sessionConfiguration: URLSessionConfiguration = NetworkDispatcher.defaultSessionConfiguration()) {
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func dispatchRequest(_ request: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionDataTask {
        
        let failUrlResponse = HTTPURLResponse(url: URL(string: "https://apple.com")!, statusCode: errorCode, httpVersion: nil, headerFields: [:])
        
        completion(nil, failUrlResponse, nil)
        receivedResponseHandler?(request)
        
        return session.dataTask(with: request)
    }
}
