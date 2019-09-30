//
//  Response.swift
//  Networking
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public struct NetworkOperationResponse{
    
    public let statusCode: Int?
    public let data: Data?
    public let response: HTTPURLResponse?
    public let request: URLRequest
}
