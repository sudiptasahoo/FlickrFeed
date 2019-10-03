//
//  SearchInteractorTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
import EasyNetworking
@testable import Flickr_Feed

final class FlickrSearchInteractorTests: XCTestCase {
    
    var interactor: SearchInteractor!
    var failInteractor: SearchInteractor!
    var presenter: SearchPresenterInputMock!
    
    override func setUp() {
        presenter = SearchPresenterInputMock()
        let network = EasyNetworkingSuccessMock()
        let failNetwork = EasyNetworkingFailureMock()
        interactor = SearchInteractor(httpNetworking: network, presenter: presenter)
        failInteractor = SearchInteractor(httpNetworking: failNetwork, presenter: presenter)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        interactor = nil
        presenter = nil
    }
    
    func testFetchPhotosWithSuccessResponse() {
        interactor.fetchPhotos(with: "car", page: 1)
        XCTAssertTrue(presenter.flickrSuccessCalled)
    }
    
    func testFetchPhotosWithErrorResponse() {
        failInteractor.fetchPhotos(with: "car", page: 1)
        XCTAssertTrue(presenter.flickrFailureCalled)
    }
}

final class SearchPresenterInputMock: SearchInteractorOutput {
    
    var flickrSuccessCalled = false
    var flickrFailureCalled = false

    func fetchPhotoCompleted(with result: Result<FlickrFeed, Error>) {
        
        switch result {
        case .success(let feed):
            flickrSuccessCalled = true
            XCTAssertFalse(feed.photos.photo.isEmpty)
            
        case .failure(let error as AppError):
            flickrFailureCalled = true
            XCTAssertNotNil(error.localizedDescription)
            
        case .failure(_):
            XCTFail("Only AppError was expected here")
        }
    }
}

