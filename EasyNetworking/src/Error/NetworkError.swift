//
//  NetworkError.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

internal let DEFAULT_ERROR_MESSAGE = "Something went wrong"

public enum NetworkError: Error {
    
    case failed(Error?)
    case outdated
    case badRequest(Dictionary<String, AnyObject>?)
    case serverError(Dictionary<String, AnyObject>?)
    case authenticationError
}

enum RequestError: Error, LocalizedError {
    
    case invalidRequest(String)
    case parametersNil
    case parameterEncodingFailed(ParameterEncodingFailureReason)
}

public enum ParameterEncodingFailureReason {
    case missingUrl
    case jsonEncoding(Error)
}

enum ResponseError: Error, LocalizedError {
    
    case unableToDecode(DecodingError)
    case noData(String)
}
