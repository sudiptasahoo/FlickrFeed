//
//  SearchViewModelTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import XCTest
@testable import FlickrFeed

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
        var urls: [URL] = []
        for _ in 0...3 {
            let url = URL(string: "https://flickr.com/example/image.jpg")!
            urls.append(url)
        }
        let viewModel = SearchViewModel(photos: urls, totalPage: 10, currentPage: 1)
        XCTAssertFalse(viewModel.photos.isEmpty)
        XCTAssertTrue(viewModel.photoCount == 4)
    }
    
    func testAddMorePhoto() {
        var urls: [URL] = []
        for _ in 0...3 {
            let url = URL(string: "https://flickr.com/example/image.jpg")!
            urls.append(url)
        }
        var viewModel = SearchViewModel(photos: urls, totalPage: 10, currentPage: 1)
        viewModel.append(urls)
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertTrue(viewModel.photoCount == 8)
    }
}
