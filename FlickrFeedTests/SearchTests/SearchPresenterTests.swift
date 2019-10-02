//
//  SearchPresenterTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
import EasyNetworking
@testable import FlickrFeed

final class SearchPresenterTests: XCTestCase {
    
    var interactor: SearchInteractorMock!
    var presenter: SearchPresenterMock!
    var view: SearchViewControllerMock!
    var router: SearchRouterInput!
    var network: NetworkService!
    
    /// Keeps the latest searched term
    var searchText: String = ""
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presenter = SearchPresenterMock()
        network = EasyNetworkingSuccessMock()
        interactor = SearchInteractorMock(presenter: presenter, network: network)
        router = SearchRouterMock()
        view = SearchViewControllerMock(presenter: presenter)
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        presenter = nil
        view = nil
        interactor = nil
        network = nil
    }
    
    func testSearchMethodCall() {
        presenter.fetchPhotos(with: "car")
        XCTAssertTrue(presenter.flickrSearchSuccess)
        XCTAssertTrue(view.showFlickrImages)
        XCTAssertNotNil(presenter.searchViewModel)
        XCTAssertTrue(presenter.searchViewModel.photos.count == 3)
    }
    
    func testDidSelectPhotoCall() {
        presenter.didSelectPhoto(at: 0)
        XCTAssertTrue(presenter.selectedPhoto)
    }
}

final class SearchPresenterMock: SearchModuleInput, SearchViewOutput, SearchInteractorOutput {
    
    weak var view: SearchViewInput?
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!
    var searchViewModel: SearchViewModel!
    
    var flickrSearchSuccess = false
    var selectedPhoto = false
    
    var searchPhotoSuccess = false
    var searchPhotoFailure = false
    
    var searchText = ""
    
    func fetchPhotos(with searchTerm: String) {
        searchText = searchTerm
        interactor.fetchPhotos(with: searchTerm, page: 1)
    }
    
    func fetchMorePhotos() {
        interactor.fetchPhotos(with: searchText, page: searchViewModel.currentPage+1)
    }
    
    func fetchPhotoUrl(with photos: [FlickrPhoto]) -> [URL] {
        return photos.compactMap { (photo) -> URL? in
            let url = "https://farm\(photo.farm).staticflickr.com.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
            guard let imageUrl = URL(string: url) else {
                return nil
            }
            return imageUrl
        }
    }
    
    func fetchPhotoCompleted(with result: Result<FlickrFeed, Error>) {
        
        switch result {
            
        case .success(let flickrFeed):
            flickrSearchSuccess = true
            XCTAssertFalse(flickrFeed.photos.photo.isEmpty)
            let photoUrlList = fetchPhotoUrl(with: flickrFeed.photos.photo)
            let viewModel = SearchViewModel(photos: photoUrlList, totalPage: flickrFeed.photos.pages, currentPage: flickrFeed.photos.page)
            self.searchViewModel = viewModel
            view?.refreshUI(using: .rendering)
            
        case .failure(let error):
            searchPhotoFailure = true
            view?.refreshUI(using: .error(message: error.localizedDescription))
        }
    }
    
    func didSelectPhoto(at index: Int) {
        selectedPhoto = true
    }
}


final class SearchViewControllerMock: UIViewController, SearchViewInput {
    
    var presenter: SearchViewOutput!
    var showFlickrImages = false
    var showErrorMessage = false
    var showLoader = false
    
    init(presenter: SearchViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshUI(using result: SearchResultState) {
        
        switch result {
        case .rendering:
            XCTAssertFalse(presenter.searchViewModel.isEmpty)
            XCTAssertTrue(presenter.searchViewModel.photos.count == 3)
            showFlickrImages = true
            
        case .error(_ ):
            showErrorMessage = true
            
        case .loading:
            showLoader = true
        }
    }
}


final class SearchRouterMock: SearchRouterInput {
    
    weak var viewController: UIViewController?
    var showFlickrPhotoDetailsCalled = false
    
    func routeToPhotoDetails(with photo: FlickrPhoto) {
        showFlickrPhotoDetailsCalled = true
    }
}
