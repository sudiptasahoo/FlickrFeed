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
    
    #warning("Verify")
    var searchTerm: String = ""
    
    //MARK: Initialization
    init() {
        searchViewModel = SearchViewModel(photos: [], totalPage: 0, currentPage: 0)
    }
    
    //MARK: SearchViewOutput methods
    
    func fetchPhotos(with searchTerm: String) {
        self.searchTerm = searchTerm
        resetViewModel()
        DispatchQueue.main.async { [unowned self] in
            self.view?.refreshUI(using: .loading)
        }
        interactor.fetchPhotos(with: searchTerm, page: Defaults.firstPage)
    }
    
    func fetchMorePhotos() {
        interactor.fetchPhotos(with: searchTerm, page: searchViewModel.currentPage + 1)
    }
    
    func fetchPhotoUrl(with photos: [FlickrPhoto]) -> [URL] {
        return photos.compactMap { (photo) -> URL? in
            let url = "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
            guard let imageUrl = URL(string: url) else {
                return nil
            }
            return imageUrl
        }
    }
    
    func didSelectPhoto(at index: Int) {
        //router.routeToPhotoDetails(with: searchViewModel.imageUrlAt(index))
    }
    
    
    //MARK: SearchInteractorOutput
    func fetchPhotoCompleted(with result: Result<FlickrFeed, Error>) {
        
        switch result {
        case .success(let flickrFeed):
            let oldCount = searchViewModel.photoCount
            process(flickrFeed)
            let indexPaths: [IndexPath] = (oldCount..<searchViewModel.photoCount).map {
                return IndexPath(item: $0, section: 0)
            }
            DispatchQueue.main.async { [unowned self] in
                self.view?.insertPhotos(at: indexPaths)
                //self.view?.refreshUI(using: .rendering)
            }
            
        case .failure(let error):
            DispatchQueue.main.async { [unowned self] in
                self.view?.refreshUI(using: .error(message: error.localizedDescription))
            }
        }
    }
    
    //MARK: Private Methods
    private func process(_ flickrFeed: FlickrFeed) {
        let photoUrlList = fetchPhotoUrl(with: flickrFeed.photos.photo)
        searchViewModel.append(photoUrlList)
        searchViewModel.currentPage = flickrFeed.photos.page
        searchViewModel.totalPage = flickrFeed.photos.pages
    }
    
    private func resetViewModel() {
        searchViewModel.reset()
    }
}

