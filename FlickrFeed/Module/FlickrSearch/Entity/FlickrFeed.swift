//
//  FlickrFeed.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

/// The root of the Flickr Search API response JSON
struct FlickrFeed : Decodable {
    
    var photos: FlickrResult
    var stat: String
}

struct FlickrResult : Decodable {
    
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [FlickrPhoto]
}

struct FlickrPhoto : Decodable {
    
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    
    /// Doubting whether Flickr API will always return title. Hence, marking it optional
    var title: String?
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}
