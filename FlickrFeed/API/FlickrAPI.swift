//
//  FlickrAPI.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import EasyNetworking

enum FlickrAPI : EndPoint {
    
    ///Searches Flickr Community with the supplied text and page no.
    case search(text: String, page: Int)
    
    var baseURL: URL {
        switch self {
        case .search(_, _ ):
            return URL(string: APIConstants.flickrAPIBaseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .search(_, _ ):
            return "services/rest/"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .search(let text, let page):
            
            let params = [
                "method": FlickrMethods.search,
                "api_key": APIConstants.flickrAPIKey,
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": text,
                "page": page,
                "per_page": Defaults.defaultPageSize
                ] as [String : AnyHashable]
            
            return .requestQueryParameters(params)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search(_, _ ):
            return .GET
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .search(_, _ ):
            return [:]
        }
    }
}

