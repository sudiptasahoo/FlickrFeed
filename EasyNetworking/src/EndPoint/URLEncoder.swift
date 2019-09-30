//
//  URLEncoder.swift
//  Networking
//
//  Created by Sudipta Sahoo on 10/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public enum URLEncoding {
    case `default`
    case queryString
    case httpBody
    case jsonEncoding(encodable: Encodable, encoder: JSONEncoder)
}

public protocol ParameterEncoding {
    func encode(_ request: URLRequest, with parameters: Parameters?) throws -> URLRequest
}


public struct URLParameterEncoding: ParameterEncoding {
    
    //MARK: encode URLRequest by appending parameters aka URLQueryItem
    public func encode(_ request: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters, !parameters.isEmpty else {
            return request
        }
        
        guard let requestUrl = request.url else {
            throw RequestError.parameterEncodingFailed(.missingUrl)
        }
        
        guard var urlComponents = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else {
            return request
        }
        
        let queryItems: [URLQueryItem] = parameters.flatMap { (parameter) in
            return queryComponents(from: parameter.key, value: parameter.value)
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        var urlEncodedRequest = request
        
        if urlEncodedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlEncodedRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        urlEncodedRequest.url = urlComponents.url
        return urlEncodedRequest
    }
    
    //MARK: create QueryItems array from [String: Any] parameters
    public func queryComponents(from key: String, value: Any) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, nestedValue) in dictionary {
                let components = queryComponents(from: "\(key)[\(nestedKey)]", value: nestedValue)
                queryItems.append(contentsOf: components)
            }
        } else if let boolValue = value as? Bool {
            let value = boolValue ? "1" : "0"
            queryItems.append(URLQueryItem(name: escape(key), value: escape(value)))
        } else {
            queryItems.append(URLQueryItem(name: escape(key), value: escape("\(value)")))
        }
        return queryItems
    }
    
    //MARK: PercentEscape String parameter
    public func escape(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
}

public struct JSONParameterEncoding: ParameterEncoding {
    
    public func encode(_ request: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters, !parameters.isEmpty else {
            return request
        }
        
        var jsonEncodedRequest = request
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            jsonEncodedRequest.httpBody = data
        } catch {
            throw RequestError.parameterEncodingFailed(.jsonEncoding(error))
        }
        
        if jsonEncodedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            jsonEncodedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return jsonEncodedRequest
    }
}

