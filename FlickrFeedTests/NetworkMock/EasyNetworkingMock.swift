//
//  EasyNetworkingMock.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 01/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import EasyNetworking
@testable import Flickr_Feed

final class EasyNetworkingSuccessMock : NetworkService {
    
    func request<T>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T: Decodable{
        
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "MockData", withExtension: "json")!
        let data = try! Data(contentsOf: fileUrl)
        let flickrFeed = try! JSONDecoder().decode(T.self, from: data)
        completion(.success(flickrFeed))
        
        return URLSession.init(configuration: .default).dataTask(with: URL(string: "https://www.apple.com")!)
    }
}

final class EasyNetworkingFailureMock : NetworkService {
    
    func request<T>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T: Decodable{
        
        completion(.failure(NSError(domain: Strings.FAILURE_MOCK, code: 1111, userInfo: nil)))
        
        return URLSession.init(configuration: .default).dataTask(with: URL(string: "https://www.apple.com")!)
    }
}
