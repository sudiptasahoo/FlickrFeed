//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Sudipta Sahoo on 10/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import XCTest
@testable import EasyNetworking


final class NetworkingTests: XCTestCase {
    
    var successNetwork: NetworkService!
    var failureNetwork: NetworkService!
    var successNetworkOperation: NetworkOperation!
    var failureNetworkOperation: NetworkOperation!
    var successNetworkDispatcher: MockSuccessDispatcher!
    var failureNetworkDispatcher: MockFailureDispatcher!
    var mockRequestBehaviour: MockRequestBehaviour!
    var blankRequestBheaviour: MockBlankRequestBehaviour!
    
    class MockBlankRequestBehaviour: RequestBehaviour {}
    
    override func setUp() {
        successNetworkDispatcher = MockSuccessDispatcher()
        failureNetworkDispatcher = MockFailureDispatcher()
        mockRequestBehaviour = MockRequestBehaviour()
        blankRequestBheaviour = MockBlankRequestBehaviour()
        
        successNetworkOperation = HTTPNetworkOperation([NetworkLogger(), StatusBarLoader(), mockRequestBehaviour], NetworkRequestPreparer(), successNetworkDispatcher)
        failureNetworkOperation = HTTPNetworkOperation([NetworkLogger(), StatusBarLoader(), blankRequestBheaviour], NetworkRequestPreparer(), failureNetworkDispatcher)
        
        successNetwork = Networking(network: successNetworkOperation)
        failureNetwork = Networking(network: failureNetworkOperation)
    }
    
    override func tearDown() {
        
        successNetwork = nil
        failureNetwork = nil
        successNetworkOperation = nil
        failureNetworkOperation = nil
        successNetworkDispatcher = nil
        failureNetworkDispatcher = nil
    }
    
    
    
    func testIfValidEndPointReturnsNonNilResponseAndData() {
        
        let expect = expectation(description: "This Expectation will expect the end of Network call until the closure is executed")
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            expect.fulfill()
        }
        
        successNetwork.request(MockAPI.successAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
        
        waitForExpectations(timeout: 60) { (error) in
            XCTAssertTrue(self.mockRequestBehaviour.modifyCalled)
            XCTAssertTrue(self.mockRequestBehaviour.willSendCalled)
            XCTAssertTrue(self.mockRequestBehaviour.didReceiveCalled)
        }
    }
    
    func testIfInValidEndPointReturnsNilResponseAndError() {
        
        failureNetwork.request(MockAPI.failureAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(_ ):
                XCTFail("Success was unexpected here")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testIfEncodablePostParamSerializesToRequestBody() {
        
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            
            guard let body = request.httpBody else {
                XCTFail("Request body was expected")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let contact = try? decoder.decode(FakeContact.self, from: body)  else {
                XCTFail("Body could not be serialized")
                return
            }
            
            XCTAssertEqual(contact.firstName, MockContact.shared.contact.firstName)
            XCTAssertEqual(contact.lastName, MockContact.shared.contact.lastName)
            XCTAssertEqual(contact.phoneNumber, MockContact.shared.contact.phoneNumber)
            XCTAssertEqual(contact.url, MockContact.shared.contact.url)
        }
        
        successNetwork.request(MockAPI.postRequest(contact: MockContact.shared.contact)) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
    }
    
    func testIfQueryParamsArePassedCorrectly() {
        
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            XCTAssertEqual(request.url?.absoluteString.contains("param1=1"), true)
            XCTAssertEqual(request.url?.absoluteString.contains("param2=2"), true)
        }
        
        successNetwork.request(MockAPI.getRequest(param1: "1", param2: "2")) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
        
    }
    
    func testIfBodyParamsArePassedCorrectly() {
        
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            
            guard let body = request.httpBody else {
                XCTFail("Request body was expected")
                return
            }
            guard let dict = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: String] else {
                XCTFail("Body could not be serialized")
                return
            }
            
            XCTAssertEqual(dict["param1"], "1")
            XCTAssertEqual(dict["param2"], "2")
        }
        
        successNetwork.request(MockAPI.bodyRequest(param1: "1", param2: "2")) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
    }
    
    func testIfHeadersArePassedCorrectly() {
        
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            XCTAssertEqual(request.allHTTPHeaderFields![Strings.headerKey], Strings.headerValue)
        }
        
        successNetwork.request(MockAPI.headerAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
    }
    
    func testIfUrlIsPassedCorrectly() {
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            XCTAssertEqual(request.url?.absoluteString, Strings.baseUrl + Strings.successPath)
        }
        
        successNetwork.request(MockAPI.successAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
    }
    
    func testIfHttpMethodIsPassedCorrectly() {
        successNetworkDispatcher.receivedResponseHandler = {(request: URLRequest) in
            XCTAssertEqual(request.httpMethod, "GET")
        }
        
        successNetwork.request(MockAPI.successAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(let fakeContact):
                XCTAssertNotNil(fakeContact)
                XCTAssertEqual(fakeContact.email, MockContact.shared.contact.email)
            case .failure(_ ):
                XCTFail("Error was unexpected here")
            }
        }
    }
    
    func testIf4xxCodeThrowsServerError() {
        
        failureNetworkDispatcher.errorCode = 403
        failureNetwork.request(MockAPI.failureAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(_ ):
                XCTFail("Success was unexpected here")
            case .failure(let error as NetworkError):
                XCTAssertNotNil(error)
                guard case .serverError = error else {
                    XCTFail("Only NetworkError.serverError was expected here")
                    return
                }
            case .failure(_):
                XCTFail("Only NetworkError was expected here")
            }
        }
    }
    
    func testIf401CodeThrowsAunthenticationError() {
        failureNetworkDispatcher.errorCode = 401
        failureNetwork.request(MockAPI.failureAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(_ ):
                XCTFail("Success was unexpected here")
            case .failure(let error as NetworkError):
                XCTAssertNotNil(error)
                guard case .authenticationError = error else {
                    XCTFail("Only NetworkError.authenticationError was expected here")
                    return
                }
            case .failure(_):
                XCTFail("Only NetworkError was expected here")
            }
        }
    }
    
    func testIf5xxCodeThrowsBadRequestError() {
        failureNetworkDispatcher.errorCode = 501
        failureNetwork.request(MockAPI.failureAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(_ ):
                XCTFail("Success was unexpected here")
            case .failure(let error as NetworkError):
                XCTAssertNotNil(error)
                guard case .badRequest = error else {
                    XCTFail("Only NetworkError.badRequest was expected here")
                    return
                }
            case .failure(_):
                XCTFail("Only NetworkError was expected here")
            }
        }
    }
    
    func testIf6xxCodeThrowsBadRequestError() {
        failureNetworkDispatcher.errorCode = 600
        failureNetwork.request(MockAPI.failureAPI) { (result: Result<FakeContact, Error>) in
            
            switch result {
            case .success(_ ):
                XCTFail("Success was unexpected here")
            case .failure(let error as NetworkError):
                XCTAssertNotNil(error)
                guard case .outdated = error else {
                    XCTFail("Only NetworkError.outdated was expected here")
                    return
                }
            case .failure(_):
                XCTFail("Only NetworkError was expected here")
            }
        }
    }
}
