//
//  XCUIElement+Extensions.swift
//  FlickrFeedUITests
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
    
    func waitForElementToBeHittable(timeout: TimeInterval) -> Bool {
        let existsPredicate = NSPredicate(format: "hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate,
                                                    object: self)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    
    /**
    Wait for the element gain back the selected state
     - Parameter selected: the state to be waited for
     */
    func waitForElementToBeSelectable(selected: Bool, timeout: TimeInterval) -> Bool {
        let existsPredicate = NSPredicate(format: "selected == \(selected)")
        let expectation = XCTNSPredicateExpectation(predicate: existsPredicate,
                                                    object: self)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}
