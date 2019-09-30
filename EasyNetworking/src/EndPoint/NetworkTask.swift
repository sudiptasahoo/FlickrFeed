//
//  NetworkTask.swift
//  Networking
//
//  Created by Sudipta Sahoo on 10/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]

public enum HTTPMethod : String {
    case GET     = "GET"
    case POST    = "POST"
    case PUT     = "PUT"
    case PATCH   = "PATCH"
    case DELETE  = "DELETE"
}

public enum HTTPTask {
    
    /// A request with no additional data.
    case requestPlain
    
    ///A request with query parameters: GET Request
    case requestQueryParameters(Parameters)
    
    /// A requests body set with parameters: POST Request
    case requestBodyParameters(Parameters)
    
    /// A request body set with `Encodable` type eg. using JSONEcoder to convert into JSON
    case requestJSONEncodable(Encodable)
    
    /// A requests body set with data, combined with url parameters.
    case requestCompositeBodyParameters(Parameters, urlParameters: [String: Any])
    
}
