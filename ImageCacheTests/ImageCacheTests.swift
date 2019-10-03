//
//  ImageCacheTests.swift
//  ImageCacheTests
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
@testable import ImageCache

final class ImageCacheTests: XCTestCase {

    let url = "https://images.pexels.com/photos/39803/pexels-photo-39803.jpeg?auto=format%2Ccompress&cs=tinysrgb&dpr=1&w=500"

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1FirstFetch() {
        
        let expect = expectation(description: "Untill the image is fetched from the server")
        var image: UIImage?
        var source: ImageFetchSource?
        EasyImage.shared.downloadImage(withURL: URL(string: url)!) { (url, dImage, dSource) in
            image = dImage
            source = dSource
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
            XCTAssertNotNil(image)
            XCTAssertNotNil(source)
            XCTAssertEqual(source, ImageFetchSource.online)
        }
    }

    func test2SecondFetch() {
        
        let expect = expectation(description: "Untill the image is fetched from the server")
        var image: UIImage?
        var source: ImageFetchSource?
        EasyImage.shared.downloadImage(withURL: URL(string: url)!) { (url, dImage, dSource) in
            image = dImage
            source = dSource
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
            XCTAssertNotNil(image)
            XCTAssertNotNil(source)
            XCTAssertEqual(source, ImageFetchSource.cache)
        }
    }
    
    func test3ClearCache() {
        
        let expect = expectation(description: "Untill the image is fetched from the server")
        var image: UIImage?
        var source: ImageFetchSource?
        EasyImage.shared.clearCache(for: URL(string: url)!)
        EasyImage.shared.downloadImage(withURL: URL(string: url)!) { (url, dImage, dSource) in
            image = dImage
            source = dSource
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
            XCTAssertNotNil(image)
            XCTAssertNotNil(source)
            XCTAssertEqual(source, ImageFetchSource.online)
        }
    }
    
    func test4ClearAllCache() {
        
        let expect = expectation(description: "Untill the image is fetched from the server")
        var image: UIImage?
        var source: ImageFetchSource?
        EasyImage.shared.clearAllCache()
        EasyImage.shared.downloadImage(withURL: URL(string: url)!) { (url, dImage, dSource) in
            image = dImage
            source = dSource
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
            XCTAssertNotNil(image)
            XCTAssertNotNil(source)
            XCTAssertEqual(source, ImageFetchSource.online)
        }
    }
}

