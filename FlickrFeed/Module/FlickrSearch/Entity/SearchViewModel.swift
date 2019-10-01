//
//  SearchViewModel.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

struct SearchViewModel {

    /// Photo Result for the current search term
    var photos: [URL]
    
    
    /// Total no of pages in the paginated result
    var totalPage: Int
    
    
    /// Last fetched page from the API
    var currentPage: Int
    
    
    var isEmpty: Bool {
        get{
            return photos.isEmpty
        }
    }
    
    mutating func append(_ photoUrls: [URL]) {
        self.photos += photoUrls
    }
    
    var photoCount: Int {
        return photos.count
    }
    
    func imageUrlAt(_ index: Int) -> URL {
        guard !photos.isEmpty else {
            fatalError("No photos available")
        }
        return photos[index]
    }
}
