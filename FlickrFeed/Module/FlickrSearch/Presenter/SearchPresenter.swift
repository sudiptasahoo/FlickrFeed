//
//  SearchPresenter.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

final class SearchPresenter: SearchViewOutput, SearchModuleInput, SearchInteractorOutput {
    
    //MARK: Properties
    var searchViewModel: SearchViewModel!
    weak var view: SearchViewInput?
    var router: SearchRouterInput!
    var interactor: SearchInteractorInput!
    var searchTerm: String = ""
    
    //MARK: Initialization
    init() {
        searchViewModel = SearchViewModel.default
    }
    
    //MARK: SearchViewOutput methods
    
    func fetchPhotosWithNew(_ searchTerm: String) {
        self.searchTerm = searchTerm
        resetViewModel()
        self.view?.updateViewState(with: .loading)
        self.view?.resetView()
        self.view?.startLoader(loadingText: Strings.searchLoaderText + searchTerm)
        interactor.fetchPhotos(with: searchTerm, page: Defaults.firstPage)
    }
    
    func fetchMorePhotos() {
        self.view?.updateViewState(with: .loading)
        interactor.fetchPhotos(with: searchTerm, page: searchViewModel.currentPage + 1)
    }
    
    func didSelectPhoto(at index: Int) {
        guard let photo = try? searchViewModel.getPhoto(at: index) else { return }
        router.routeToPhotoDetails(with: photo)
    }
    
    
    //MARK: SearchInteractorOutput
    func fetchPhotoCompleted(with result: Result<FlickrFeed, Error>) {
        
        self.view?.stopLoader()
        switch result {
        case .success(let flickrFeed):
            let oldCount = searchViewModel.photoCount
            process(flickrFeed)
            let indexPaths: [IndexPath] = (oldCount..<searchViewModel.photoCount).map {
                return IndexPath(item: $0, section: 0)
            }
            DispatchQueue.main.async { [unowned self] in
                self.view?.updateViewState(with: .content)
                self.view?.insertPhotos(at: indexPaths)
            }
            
        case .failure(let error):
            DispatchQueue.main.async { [unowned self] in
                self.view?.updateViewState(with: .error(message: error.localizedDescription))
            }
        }
    }
    
    //MARK: Private Methods
    
    /// Assigns values from the freshly fetched response to the view model
    private func process(_ flickrFeed: FlickrFeed) {
        searchViewModel.append(flickrFeed.photos.photo)
        searchViewModel.currentPage = flickrFeed.photos.page
        searchViewModel.totalPage = flickrFeed.photos.pages
    }
    
    /// Resets the View Model to its default values
    private func resetViewModel() {
        searchViewModel.reset()
    }
}

