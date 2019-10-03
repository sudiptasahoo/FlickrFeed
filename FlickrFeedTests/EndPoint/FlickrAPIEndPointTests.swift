//
//  FlickrAPIEndPointTests.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 03/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import XCTest
@testable import Flickr_Feed

final class FlickrAPIEndPointTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBaseUrlIsSet() {
        let api = FlickrAPI.search(text: "car", page: 1)
        XCTAssertEqual(api.baseURL.absoluteString, APIConstants.flickrAPIBaseURL)
    }
    
    func testApiKeyIsSet() {
        let api = FlickrAPI.search(text: "car", page: 1)
        
        switch api.task {
        case .requestQueryParameters(let params):
            XCTAssertEqual(params["api_key"] as? String, APIConstants.flickrAPIKey)
        default:
            XCTFail("Flickr Search API params should be query params")
        }
    }
    
    func testParametersAreSet() {
        let api = FlickrAPI.search(text: "car", page: 1)
        
        switch api.task {
        case .requestQueryParameters(let params):
            XCTAssertEqual(params["text"] as? String, "car")
            XCTAssertEqual(params["page"] as? Int, 1)
            XCTAssertEqual(params["method"] as? String, FlickrMethods.search)
            XCTAssertEqual(params["per_page"] as? Int, Defaults.defaultPageSize)
            
        default:
            XCTFail("Flickr Search API params should be query params")
        }
    }
    
    func testHttpMethod() {
        let api = FlickrAPI.search(text: "car", page: 1)
        XCTAssertEqual(api.method, .GET)
    }
}
