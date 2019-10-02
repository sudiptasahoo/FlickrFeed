//
//  Constants.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

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
    static let firstPage: Int = 1
    static let defaultCellSpacing: CGFloat = 1.0
    static let gridNoOfColumns: CGFloat = 3.0
}

//MARK: Copies
enum Strings {
    static let searchPlaceholder = "Search Photos"
    static let searchVcTitle = "Flickr Feed"
}

//MARK: Metrics
enum Metrics {
    static let screenWidth = UIScreen.main.bounds.width
}
