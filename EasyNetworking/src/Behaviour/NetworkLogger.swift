//
//  NetworkLogger.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

/// This is one of the default behaviours provided with the Networking module, this behaviour logs the request and response involved in the Network Operation.
public struct NetworkLogger: RequestBehaviour {
    
    public init() {}
    
    public func willSend(_ request: URLRequest, endPoint: EndPoint) {
        
        print("\n - - - - - - - - OUTGOING REQUEST- - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
    
    public func didReceive(_ result: Result<NetworkOperationResponse, Error>, endPoint: EndPoint) {
        
        print("\n - - - - - - - - INCOMING RESPONSE- - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END \(endPoint.baseURL)\(endPoint.path)- - - - - - - - - - \n") }

        switch result {
        case .success(let response):
            
            if let data = response.data, !data.isEmpty {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let jsonString = String(data: prettyData, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
                    print("JSON: \(jsonString)")
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
