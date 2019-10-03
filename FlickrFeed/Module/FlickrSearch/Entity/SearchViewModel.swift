//
//  SearchViewModel.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

struct SearchViewModel {
    
    static let `default` = SearchViewModel(photos: [], photoUrls: [], totalPage: Defaults.defaultTotalCount, currentPage: Defaults.defaultPageNum)
    
    
    /// Photo Result for the current search term
    private var photos: [FlickrPhoto]
    
    ///Cached Image URLs
    ///Caching the Image URLs before rendering will help in more performance and smooth scrolling
    private var photoUrls: [URL]
    
    /// Total no of pages in the paginated result
    var totalPage: Int
    
    
    /// Last fetched page from the API
    var currentPage: Int
    
    
    /// Whether ViewModel has any photos
    var isEmpty: Bool {
        get{
            return photos.isEmpty
        }
    }
    
    /// Append freshly photos fetches from the API
    mutating func append(_ photos: [FlickrPhoto]) {
        self.photos += photos
        photoUrls += (try? fetchPhotoUrl(from: photos)) ?? []
    }
    
    /// Total count of the photos
    var photoCount: Int {
        return photos.count
    }
    
    /// Returns ImageURL at the specified index
    /// - Parameter index: requested index
    func imageUrl(at index: Int) throws -> URL {
        guard let photoUrl = photoUrls[safe: index] else {
            throw AppError.photoError(.noPhotoPresent)
        }
        return photoUrl
    }
    
    /// Returns FlickrPhoto at the specified index
    /// - Parameter index: requested index no
    func getPhoto(at index: Int) throws -> FlickrPhoto {
        guard let photo = photos[safe: index] else {
            throw AppError.photoError(.noPhotoPresent)
        }
        return photo
    }
    
    /// Reset the ViewModel before fetching results for new search term from the API
    mutating func reset() {
        photos = []
        photoUrls = []
        currentPage = Defaults.defaultPageNum
        totalPage = Defaults.defaultTotalCount
    }
    
    /// Constructs image URLs from the provided array of FlickrPhoto
    /// Pre caching of constructed image URL will save computation during the collectionview/tableview scroll. Hence, smooth scroll
    /// a + b is faster than "\(a)\(b)". Ref: http://www.globalnerdy.com/2016/02/03/concatenating-strings-in-swift-which-way-is-faster/
    /// - Parameter photos: array of newly fetched FlickrPhoto to be used as source for the construction of image URL
    private func fetchPhotoUrl(from photos: [FlickrPhoto]) throws -> [URL] {
        
        return try photos.compactMap { (photo) -> URL? in
            let url = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
            guard let imageUrl = URL(string: url) else {
                throw AppError.photoError(.invalidUrl)
            }
            return imageUrl
        }
    }
}
