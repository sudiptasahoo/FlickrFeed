//
//  NetworkOperation.swift
//  Networking
//
//  Created by Sudipta Sahoo on 10/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public typealias NetworkOperationCompletion = (_ result: Result<NetworkOperationResponse, Error>)->()
public typealias NetworkDispatchCompletion  = (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?)->()

public protocol NetworkOperation {
    
    associatedtype NetworkPreparer = NetworkRequestPreparable
    associatedtype NetworkDispatcher = NetworkDispatchable
    associatedtype NetworkRequestBehaviours = RequestBehaviour
    
    var requestBehaviours: [NetworkRequestBehaviours] { get set }
    var requestDispatcher: NetworkDispatcher { get set }
    var requestPreparer: NetworkPreparer { get set }
    
    /**
     Takes an EndPoint and dispatches the network call.
     - parameter route: It takes the API EndPoint
     - parameter completion: It takes a closure with Swift Result
     */
    func request(_ route: EndPoint, completion: @escaping NetworkOperationCompletion) -> URLSessionDataTask?
    
}


struct HTTPNetworkOperation: NetworkOperation{
    
    var requestBehaviours: [RequestBehaviour]
    
    var requestDispatcher: NetworkDispatchable
    
    var requestPreparer: NetworkRequestPreparable
    
    init(_ requestBehaviours: [RequestBehaviour], _ requestPreparer: NetworkRequestPreparable, _ requestDispatcher: NetworkDispatchable){
        self.requestBehaviours = requestBehaviours
        self.requestDispatcher = requestDispatcher
        self.requestPreparer = requestPreparer
    }
    
    public func request(_ route: EndPoint, completion: @escaping (Result<NetworkOperationResponse, Error>) -> ()) -> URLSessionDataTask? {
        
        do {
            //Prepare the request
            var request = try requestPreparer.prepareRequest(route)
            
            //Execute `Modify Request Behaviour`
            requestBehaviours.forEach{ $0.modify(&request, endPoint: route) }
            
            //Execute `Will Send Behaviour`
            requestBehaviours.forEach{ $0.willSend(request, endPoint: route) }
            
            //Dispatch the prepared request
            return requestDispatcher.dispatchRequest(request) { (data, response, taskError) in
                
                let result: Result<NetworkOperationResponse, Error> = self.convertResponseToResult(response, data: data, error: taskError, request: request)
                
                //Execute `Did receive response`
                self.requestBehaviours.forEach{ $0.didReceive(result, endPoint: route) }
                
                completion(result)
            }
            
        } catch let error{
            completion(.failure(error))
        }
        
        return nil
    }
    
    
    /// This method is responsible for converting the result of a `URLRequest` to a Result<Response, NetworkError>.
    func convertResponseToResult(_ response: HTTPURLResponse?, data: Data?, error: Error?, request: URLRequest) -> Result<NetworkOperationResponse, Error> {
        
        guard error == nil else { return .failure(NetworkError.failed(error)) }
        guard let response = response else { return .failure(ResponseError.noData("No response received")) }
        
        switch response.statusCode {
            
        case 200..<300:
            
            return .success(NetworkOperationResponse(statusCode: response.statusCode, data: data, response: response, request: request))
            
        case 401: return .failure(NetworkError.authenticationError)
        case 402..<500: return .failure(NetworkError.serverError(data?.toJson))
        case 500..<600: return .failure(NetworkError.badRequest(data?.toJson))
        case 600: return .failure(NetworkError.outdated)
        default: return .failure(NetworkError.failed(error))
            
        }
    }
}

internal extension Data{
    
    var toJson: Dictionary<String, AnyObject>?{
        return try? JSONSerialization.jsonObject(with: self, options: []) as? Dictionary<String, AnyObject>
    }
}
