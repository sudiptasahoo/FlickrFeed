//
//  RequestPreparer.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public protocol NetworkRequestPreparable {
    func prepareRequest(_ route: EndPoint) throws -> URLRequest
}

public struct NetworkRequestPreparer: NetworkRequestPreparable{
    
    public func prepareRequest(_ route: EndPoint) throws -> URLRequest {
        
        do{
            let url = route.baseURL.appendingPathComponent(route.path)
            var request = try encodedURLRequest(withURL: url, task: route.task)
            request.httpMethod = route.method.rawValue
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            request.timeoutInterval = 60.0
            request.allHTTPHeaderFields = route.headers
            
            return request
            
        } catch {
            throw error
        }
    }
}

extension NetworkRequestPreparer{
    
    /// Encode URLRequest based on encoding policy
    internal func encodedURLRequest(withURL requestURL: URL, task: HTTPTask) throws -> URLRequest {
        var request = URLRequest(url: requestURL)
        
        switch task {
        case .requestPlain:
            return request
        case .requestQueryParameters(let parameters):
            return try request.encoded(parameters: parameters, parameterEncoding: URLParameterEncoding())
        case .requestBodyParameters(parameters: let parameters):
            return try request.encoded(parameters: parameters, parameterEncoding: JSONParameterEncoding())
        case .requestJSONEncodable(let encodable):
            return try request.encoded(encodable: encodable)
        case .requestCompositeBodyParameters(let bodyParameters, let urlParameters):
            request = try request.encoded(parameters: bodyParameters, parameterEncoding: JSONParameterEncoding())
            request = try request.encoded(parameters: urlParameters, parameterEncoding: URLParameterEncoding())
            return request
        }
    }
}
