//
//  EndPoint.swift
//  Networking
//
//  Created by Sudipta Sahoo on 10/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation

public protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var task: HTTPTask { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}

extension EndPoint {
    var headers: HTTPHeaders? {
        get {
            return [:]
        }
    }
}
