//
//  Constants.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

//MARK: Networking API Constants
enum APIConstants {
    static let flickrAPIBaseURL = "https://api.flickr.com/"
    static let flickrAPIKey = "0d83713732a05a0b725ba910458216ee"
}

enum FlickrMethods {
    static let search = "flickr.photos.search"
}

//MARK: App Defaults
enum Defaults {
    static let defaultPageSize: Int = 20
}
