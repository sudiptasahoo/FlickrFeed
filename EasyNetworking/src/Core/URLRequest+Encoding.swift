//
//  URLRequest+Encoding.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    mutating func encoded(encodable: Encodable, using encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let anyEncodable = AnyEncodable(encodable: encodable)
            let encodedData = try encoder.encode(anyEncodable)
            httpBody = encodedData
            if value(forHTTPHeaderField: "Content-Type") == nil {
                setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            return self
        } catch {
            throw RequestError.parameterEncodingFailed(.jsonEncoding(error))
        }
    }
    
    mutating func encoded(parameters: [String: Any], parameterEncoding: ParameterEncoding) throws -> URLRequest {
        return try parameterEncoding.encode(self, with: parameters)
    }
    
    mutating func encodeRequest(parameters: [String: Any], encoding: URLEncoding) throws -> URLRequest {
        switch encoding {
        case .default, .queryString:
            return try URLParameterEncoding().encode(self, with: parameters)
        case .httpBody:
            return try JSONParameterEncoding().encode(self, with: parameters)
        case .jsonEncoding(let encodable, let encoder):
            return try self.encoded(encodable: encodable, using: encoder)
        }
    }
}

internal struct AnyEncodable: Encodable {
    let encodable: Encodable
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
