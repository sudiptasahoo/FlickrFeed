//
//  SearchPresenterTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
import EasyNetworking
@testable import Flickr_Feed

final class SearchPresenterTests: XCTestCase {
    
    var interactor: SearchInteractorMock!
    var presenter: SearchPresenter!
    var view: SearchViewControllerMock!
    var router: SearchRouterMock!
    var network: NetworkService!
    
    /// Keeps the latest searched term
    var searchText: String = ""
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        presenter = SearchPresenter()
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
    
    func test1SearchMethodCall() {
        let expect  = expectation(description: "Async Task Expectation")
        view.postRendered = { () -> Void in
            expect.fulfill()
        }

        presenter.fetchPhotosWithNew("car")
        waitForExpectations(timeout: 60) { (error) in
            XCTAssertTrue(self.view.showFlickrImages)
            XCTAssertNotNil(self.presenter.searchViewModel)
            XCTAssertTrue(self.presenter.searchViewModel.photoCount == 3)
        }
    }
    
    func test2MorePhotosFetchCall() {
        let expect  = expectation(description: "Async Task Expectation")
        view.postRendered = { () -> Void in
            expect.fulfill()
        }

        presenter.fetchMorePhotos()
        waitForExpectations(timeout: 60) { (error) in
            XCTAssertTrue(self.view.showFlickrImages)
            XCTAssertNotNil(self.presenter.searchViewModel)
            XCTAssertTrue(self.presenter.searchViewModel.photoCount == 3)
            XCTAssertNotNil(try? self.presenter.searchViewModel.imageUrl(at: 2))
        }
    }
        
    func test3DidSelectPhotoCall() {
        presenter.fetchPhotosWithNew("car")
        presenter.didSelectPhoto(at: 0)
        XCTAssertTrue(router.showFlickrPhotoDetailsCalled)
    }
}

final class SearchInteractorMock: SearchInteractorInput {

    weak var presenter: SearchInteractorOutput?
    var loadPhotosSuccess: Bool = false
    var loadPhotosFailure: Bool = false
    var network: NetworkService?

    init(presenter: SearchInteractorOutput, network: NetworkService) {
        self.presenter = presenter
        self.network = network
    }

    func fetchPhotos(with searchTerm: String, page: Int) {
        network?.request(FlickrAPI.search(text: searchTerm, page: page), completion: { (result: Result<FlickrFeed, Error>) in
            switch result {
            case let .success(flickrPhotos):
                self.loadPhotosSuccess = true
                self.presenter?.fetchPhotoCompleted(with: .success(flickrPhotos))
            case let .failure(error):
                self.loadPhotosFailure = true
                self.presenter?.fetchPhotoCompleted(with: .failure(error))
            }
        })
    }
}

final class SearchViewControllerMock: UIViewController, SearchViewInput {
    
    var presenter: SearchViewOutput!
    var showFlickrImages = false
    var showErrorMessage = false
    var showLoader = false
    var listCount = 0
    var postRendered: (() -> Void)?

    init(presenter: SearchViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViewState(with result: ViewState) {
        
        switch result {
            
        case .none: break
        case .content:
            XCTAssertFalse(presenter.searchViewModel.isEmpty)
            XCTAssertTrue(presenter.searchViewModel.photoCount == 3)
            showFlickrImages = true
            postRendered?()
        case .error(_ ):
            showErrorMessage = true
            
        case .loading:
            showLoader = true
        }
    }
    
    func insertPhotos(at indexPaths: [IndexPath]) {
        listCount += indexPaths.count
    }
    
    func resetView() {
        listCount = 0
    }
}


final class SearchRouterMock: SearchRouterInput {
    
    weak var viewController: UIViewController?
    var showFlickrPhotoDetailsCalled = false
    
    func routeToPhotoDetails(with photo: FlickrPhoto) {
        showFlickrPhotoDetailsCalled = true
    }
}
