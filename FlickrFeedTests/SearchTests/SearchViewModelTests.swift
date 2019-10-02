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

    func testViewModelUrlEmptyList() {
        let viewModel = SearchViewModel(photos: [], totalPage: 10, currentPage: 1)
        XCTAssertTrue(viewModel.isEmpty)
    }
    
    func testViewModelUrlListNotEmpty() {
        let viewModel = SearchViewModel(photos: MockUtil.shared.mockPhotos, totalPage: 10, currentPage: 1)
        XCTAssertFalse(viewModel.photos.isEmpty)
        XCTAssertTrue(viewModel.photoCount == 4)
    }
    
    func testAddMorePhoto() {
        let photos = MockUtil.shared.mockPhotos
        var viewModel = SearchViewModel(photos: photos, totalPage: 10, currentPage: 1)
        viewModel.append(photos)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertTrue(viewModel.photoCount == 8)
    }
}
