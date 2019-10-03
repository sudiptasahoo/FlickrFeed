//
//  AppError.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 03/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import EasyNetworking


enum AppError: Swift.Error {
    case photoError(PhotoError)
    case networkError(NetworkError)
}

extension AppError: LocalizedError {
    
    var localizedDescription: String? {
        switch self {
        case .photoError(let error):
            return error.errorDescription
        case .networkError( _):
            return Errors.networkErrorMessage
        }
    }
    
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        return localizedDescription
    }
}


enum PhotoError: Swift.Error {
    case invalidUrl
    case noPhotoPresent
}

extension PhotoError: LocalizedError {
    
    var localizedDescription: String? {
        switch self {
        case .invalidUrl:
            return Errors.invalidPhotoUrl
        case .noPhotoPresent:
            return Errors.noPhoto
        }
    }
    
    /// A localized message describing what error occurred.
    var errorDescription: String? {
        return localizedDescription
    }
}
