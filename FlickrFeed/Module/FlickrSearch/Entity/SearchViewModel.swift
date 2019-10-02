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
    var photos: [FlickrPhoto]
    
    
    /// Total no of pages in the paginated result
    var totalPage: Int
    
    
    /// Last fetched page from the API
    var currentPage: Int
    
    
    var isEmpty: Bool {
        get{
            return photos.isEmpty
        }
    }
    
    mutating func append(_ photoUrls: [FlickrPhoto]) {
        self.photos += photoUrls
    }
    
    var photoCount: Int {
        return photos.count
    }
    
    func imageUrl(at index: Int) -> URL {
        guard !photos.isEmpty else {
            fatalError("No photos available")
        }
        
        return fetchPhotoUrl(with: getPhoto(at: index))
    }
    
    private func fetchPhotoUrl(with photo: FlickrPhoto) -> URL {
        
        let url = "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
        guard let imageUrl = URL(string: url) else {
            fatalError("Invalid Photo URL")
        }
        return imageUrl
    }
    
    func getPhoto(at index: Int) -> FlickrPhoto {
        guard let photo = photos[safe: index] else {
            fatalError("No photo available at index \(index)")
        }
        return photo
    }
    
    mutating func reset() {
        photos = []
        currentPage = Defaults.defaultPageNum
        totalPage = Defaults.defaultTotalCount
    }
}
