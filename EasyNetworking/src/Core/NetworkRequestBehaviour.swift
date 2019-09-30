//
//  NetworkRequestBehaviour.swift
//  Networking
//
//  Created by Sudipta Sahoo on 12/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public protocol RequestBehaviour {
    
    ///This method will be responsible to modify the request after it's just prepared. Eg. Signing the request with OAuth 1.0/2.0
    func modify(_ request: inout URLRequest, endPoint: EndPoint)
    
    ///This method will be executed just before it's dispatched Eg. Logging the URLRequest
    func willSend(_ request: URLRequest, endPoint: EndPoint)
    
    ///This method wil be executed once Networking Operation is completed.
    func didReceive(_ result: Result<NetworkOperationResponse, Error>, endPoint: EndPoint)
}

// Default implementations. This is will enable the Behaviours to implement only those methods which are required.
public extension RequestBehaviour {
    func modify(_ request: inout URLRequest, endPoint: EndPoint) { }
    func willSend(_ request: URLRequest, endPoint: EndPoint) { }
    func didReceive(_ result: Result<NetworkOperationResponse, Error>, endPoint: EndPoint) { }
}
