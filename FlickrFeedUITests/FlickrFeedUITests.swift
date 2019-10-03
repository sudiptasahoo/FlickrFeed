//
//  FlickrFeedUITests.swift
//  FlickrFeedUITests
//
//  Created by Sudipta Sahoo on 28/09/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
@testable import Flickr_Feed

final class FlickrFeedUITests: XCTestCase {
    
    let app = XCUIApplication()
    let searchTerm = "car"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFlickrFeedApp() {
        
        //Wait till the Listing page is rendered
        if app.navigationBars["Flickr Feed"].waitForExistence(timeout: 60){
            searchPhotoFlow()
        }
    }
    
    func searchPhotoFlow(){
        
        let contactNavigationBar = app.navigationBars["Flickr Feed"]
        let searchField = contactNavigationBar.searchFields.firstMatch
        edit(field: searchField)
    }
    
    
    func edit(field: XCUIElement) {
        field.tap()
        field.clearAndEnterText(text: searchTerm)
        tapReturnSearchKey()
        checkExistanceOfCells()
    }
    
    func checkExistanceOfCells() {
        
        let cell = app.collectionViews.firstMatch.cells["Photo0"]
        if cell.waitForExistence(timeout: 60){
            cell.tap()
            XCTAssert(true)
        }
    }
    
    func tapReturnSearchKey() {
        app.keyboards.buttons["Search"].tap()
    }
    
//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
