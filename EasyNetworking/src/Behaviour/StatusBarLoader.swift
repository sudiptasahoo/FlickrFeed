//
//  StatusBarLoader.swift
//  Networking
//
//  Created by Sudipta Sahoo on 16/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation


/// This is one of the default behaviour provided with the Networking module, this behaviour starts the status bar loader when request is dispatched and stops the status bar when network operation is over
public struct StatusBarLoader: RequestBehaviour {
    
    public init() {}
    
    public func willSend(_ request: URLRequest, endPoint: EndPoint) {
        
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
    }
    
    public func didReceive(_ result: Result<NetworkOperationResponse, Error>, endPoint: EndPoint) {
        
//        DispatchQueue.main.async {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
    }
}
