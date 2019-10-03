//
//  SearchProtocols.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

enum ViewState : Equatable {
    case none
    case loading
    case content
    case error(message: String)
}

//MARK: View
protocol SearchViewInput: Loadable {
    
    /// Refreshes the search screen UI
    /// - Parameter state: intended view state
    func updateViewState(with state: ViewState)
    
    /// Insert Photos at specified index path of collection view
    /// - Parameter indexPaths: list of index paths to be inserted at
    func insertPhotos(at indexPaths: [IndexPath])
    
    /// Prepare view to present results from new search term
    func resetView()
}

//MARK: Presenter
protocol SearchViewOutput: class {
    
    /// The single source of truth about the current state
    var searchViewModel: SearchViewModel! { get }

    /// Fetch Photos with the supplied FRESH search term
    /// - Parameter searchTerm: Search term entered by the user
    func fetchPhotosWithNew(_ searchTerm: String)
    
    /// Fetches incremental pages
    func fetchMorePhotos()
    
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

//MARK: SearchModuleBuilder
protocol SearchBuilder {
    static func buildModule() -> SearchViewController
}
