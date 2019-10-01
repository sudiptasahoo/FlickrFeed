//
//  SearchInteractorTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
import EasyNetworking
@testable import FlickrFeed

final class FlickrSearchInteractorTests: XCTestCase {
    
    var interactor: SearchInteractorMock!
    var failInteractor: SearchInteractorMock!
    var presenter: SearchPresenterInputMock!
    
    override func setUp() {
        presenter = SearchPresenterInputMock()
        let network = EasyNetworkingSuccessMock()
        let failNetwork = EasyNetworkingFailureMock()
        interactor = SearchInteractorMock(presenter: presenter, network: network)
        failInteractor = SearchInteractorMock(presenter: presenter, network: failNetwork)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        interactor = nil
        presenter = nil
    }
    
    func testFetchFlickrPhotos() {
        interactor.fetchPhotos(with: "car", page: 1)
        XCTAssertTrue(presenter.flickrSuccessCalled)
        XCTAssertTrue(interactor.loadPhotosCalled)
    }
    
    func testFetchFlickrPhotosErrorResponse() {
        failInteractor.fetchPhotos(with: "car", page: 1)
        XCTAssertFalse(presenter.flickrSuccessCalled)
        XCTAssertTrue(interactor.loadPhotosCalled)
    }
}


final class SearchInteractorMock: SearchInteractorInput {
    
    weak var presenter: SearchInteractorOutput?
    var loadPhotosCalled: Bool = false
    var network: NetworkService?
    
    init(presenter: SearchInteractorOutput, network: NetworkService) {
        self.presenter = presenter
        self.network = network
    }
    
    func fetchPhotos(with searchTerm: String, page: Int) {
        network?.request(FlickrAPI.search(text: searchTerm, page: page), completion: { (result: Result<FlickrFeed, Error>) in
            switch result {
            case let .success(flickrPhotos):
                self.loadPhotosCalled = true
                self.presenter?.fetchPhotoCompleted(with: .success(flickrPhotos))
            case let .failure(error):
                self.presenter?.fetchPhotoCompleted(with: .failure(error))
                self.loadPhotosCalled = true
            }
        })
    }
    
    
}

final class SearchPresenterInputMock: SearchInteractorOutput {
    
    var flickrSuccessCalled = false

    func fetchPhotoCompleted(with result: Result<FlickrFeed, Error>) {
        
        switch result {
        case .success(let feed):
            flickrSuccessCalled = true
            XCTAssertFalse(feed.photos.photo.isEmpty)
            
        default:
            flickrSuccessCalled = false
        }
    }
}

