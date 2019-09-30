//
//  NetworkBuilder.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

//MARK: NetworkService
public protocol NetworkService: class {
    
    @discardableResult
    func request<T: Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask?
}

public final class Networking: NetworkService{
    
    private let network = HTTPNetworkOperation([NetworkLogger(), StatusBarLoader()], NetworkRequestPreparer(), NetworkDispatcher())
    
    /// Gives a singleton instance of Networking class
    public static let shared = Networking()
    
    private init() {}
    
    /**
     This method takes EndPoint and returns the URLSessionDataTask
     - paramter endPoint: The API EndPoint
     - parameter completion: It takes a closure with Swift Result
     - Returns: Cancellable URLSessionDataTask
     */
    @discardableResult
    public func request<T>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T : Decodable {
        
        return network.request(endPoint) { (result: Result<NetworkOperationResponse, Error>) in
            
            switch result {
            case .success(let response):
                do {
                    
                    guard let data = response.data else {
                        completion(.failure(ResponseError.noData("No Data received")))
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy     = .convertFromSnakeCase
                    decoder.dateDecodingStrategy    = .iso8601
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch let error as DecodingError{
                    completion(.failure(ResponseError.unableToDecode(error)))
                } catch let error{
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
