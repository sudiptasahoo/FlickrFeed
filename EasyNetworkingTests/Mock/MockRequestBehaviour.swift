//
//  MockRequestBehaviour.swift
//  EasyNetworkingTests
//
//  Created by Sudipta Sahoo on 03/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
@testable import EasyNetworking

final class MockRequestBehaviour: RequestBehaviour {
    
    var modifyCalled = false
    var willSendCalled = false
    var didReceiveCalled = false
    
    func modify(_ request: inout URLRequest, endPoint: EndPoint) {
        modifyCalled = true
    }
    
    func willSend(_ request: URLRequest, endPoint: EndPoint) {
        willSendCalled = true
    }
    
    func didReceive(_ result: Result<NetworkOperationResponse, Error>, endPoint: EndPoint) {
        didReceiveCalled = true
    }
}
