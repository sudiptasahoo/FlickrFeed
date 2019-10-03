//
//  MockEndPoint.swift
//  EasyNetworkingTests
//
//  Created by Sudipta Sahoo on 03/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
@testable import EasyNetworking

enum MockAPI: EndPoint {
    case successAPI
    case failureAPI
    case postRequest(contact: FakeContact)
    case bodyRequest(param1: String, param2: String)
    case getRequest(param1: String, param2: String)
    case headerAPI
    
    var baseURL: URL {
        return URL(string: Strings.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .successAPI:
            return Strings.successPath
        default:
            return "mockTest/path/testing"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .successAPI, .failureAPI, .headerAPI:
            return .requestPlain
            
        case .postRequest(let contact):
            return .requestJSONEncodable(contact)
            
        case .bodyRequest(let param1, let param2):
            let params = ["param1": param1, "param2": param2]
            return .requestBodyParameters(params)
            
        case .getRequest(let param1, let param2):
            let params = ["param1": param1, "param2": param2]
            return .requestQueryParameters(params)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postRequest(_ ):
            return .POST
        default:
            return .GET
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .headerAPI:
            return [Strings.headerKey: Strings.headerValue]
        default:
            return [:]
        }
    }
}
