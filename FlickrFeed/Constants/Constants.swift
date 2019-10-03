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
public enum Defaults {
    static let defaultPageSize: Int = 30
    static let firstPage: Int = 1
    static let defaultCellSpacing: CGFloat = 1.0
    static let gridNoOfColumns: CGFloat = 3.0
    static let defaultPageNum: Int = 0
    static let defaultTotalCount: Int = 0
}

//MARK: Copies
public enum Strings {
    static let searchPlaceholder = "Search Photos"
    static let searchVcTitle = "Flickr Feed"
    static let error = "Error Occurred"
    static let ok = "OK"
    static let retry = "RETRY"
    static let cancel = "CANCEL"
    static let defaultBlankListText = "Type in the Search Bar to start ..."
    static let searchLoaderText = "Searching "
}

//MARK: Metrics
enum Metrics {
    static let screenWidth = UIScreen.main.bounds.width
}

//MARK:- UI Testing identifiers
public enum UITest {
    static let searchBar = "search_bar"
    static let collectionView = "photo_collection"
}

//MARK: Images
enum Images {
    static let imagePlaceholder = "imagePlaceholder"
}

enum Errors {
    static let networkErrorMessage = "Something went wrong"
    static let invalidPhotoUrl = "Photo URL could not be constructed"
    static let noPhoto = "No photo present at this index"
}
