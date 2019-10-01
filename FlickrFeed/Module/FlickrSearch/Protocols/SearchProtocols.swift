//
//  SearchProtocols.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

enum SearchResultState {
    case loading
    case rendering
    case error(message: String)
}

//MARK: View
protocol SearchViewInput: class {
    
    /// Refreshes the search screen UI
    /// - Parameter result: result state of the Flickr Search
    func refreshUI(using result: SearchResultState)
}

//MARK: Presenter
protocol SearchViewOutput: class {
    
    /// The single source of truth about the current state
    var searchViewModel: SearchViewModel! { get }

    /// Fetch Photos with the supplied FRESH search term
    /// - Parameter searchTerm: Search term entered by the user
    func fetchPhotos(with searchTerm: String)
    
    /// Fetches incremental pages
    func fetchMorePhotos()
    
    /// Constructs the Photo URL
    /// - Parameter photo: FlickrPhoto instance whose URL is to be constructed
    func fetchPhotoUrl(with photos: [FlickrPhoto]) -> [URL]
    
    /// Photo was tapped by the user
    /// - Parameter index: the index location of the photo
    func didSelectPhoto(at index: Int)
}

//MARK: Module Dependency resolver
protocol SearchModuleInput: class {
    //MARK: Presenter Variables
    var view: SearchViewInput? { get set }
    var interactor: SearchInteractorInput! { get set }
    var router: SearchRouterInput! { get set }
}

//MARK: Interactor
protocol SearchInteractorInput: class {
    
    /// Fetch Photos with the supplied search term and page no.
    /// - Parameter searchTerm: Search term entered by the user
    /// - Parameter page: current page no user has scrolled to
    func fetchPhotos(with searchTerm: String, page: Int)
}

protocol SearchInteractorOutput: class {
    
    
    /// Provides the Fetched result to the Presenter
    /// - Parameter result: The result of the fetch photo task
    func fetchPhotoCompleted(with result: Swift.Result<FlickrFeed, Error>)
}

//MARK: Router
protocol SearchRouterInput: class {
    
    /// Route to the Photo Details screen
    /// - Parameter photo: instance of teh Photo whose details page is being requested
    func routeToPhotoDetails(with photo: FlickrPhoto)
}

