//
//  SearchViewModelTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import XCTest
@testable import Flickr_Feed

final class SearchViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelDefaultInit() {
        let viewModel = SearchViewModel.default
        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertEqual(Defaults.defaultPageNum, viewModel.currentPage)
        XCTAssertEqual(Defaults.defaultTotalCount, viewModel.totalPage)
    }
    
    func testViewModelPhotoAppend() {
        var viewModel = SearchViewModel.default
        viewModel.append(MockUtil.shared.mockPhotos)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertNotNil(try viewModel.imageUrl(at: 1))
        XCTAssertEqual("1", try viewModel.getPhoto(at: 1).id)
        XCTAssertTrue(viewModel.photoCount == 4)
    }
    
    func testAddMorePhoto() {
        let photos = MockUtil.shared.mockPhotos
        var viewModel = SearchViewModel.default
        viewModel.append(photos)
        viewModel.append(photos)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertTrue(viewModel.photoCount == 8)
        XCTAssertNotNil(try viewModel.imageUrl(at: 7))
    }
    
    func testViewModelReset() {
        
        var viewModel = SearchViewModel.default
        viewModel.append(MockUtil.shared.mockPhotos)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertEqual("1", try viewModel.getPhoto(at: 1).id)
        viewModel.reset()
        XCTAssertTrue(viewModel.isEmpty)
        XCTAssertTrue(viewModel.photoCount == 0)
        XCTAssertEqual(Defaults.defaultPageNum, viewModel.currentPage)
        XCTAssertEqual(Defaults.defaultTotalCount, viewModel.totalPage)
    }
    
    func testViewModelThrows() {
        var viewModel = SearchViewModel.default
        //4 photos are being inserted
        viewModel.append(MockUtil.shared.mockPhotos)
        XCTAssertThrowsError(try viewModel.getPhoto(at: 4))
        XCTAssertThrowsError(try viewModel.imageUrl(at: 5))
        XCTAssertNoThrow(try viewModel.imageUrl(at: 3))
        XCTAssertNoThrow(try viewModel.getPhoto(at: 2))
    }
}
