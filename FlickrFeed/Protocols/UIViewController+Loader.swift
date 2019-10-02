//
//  UIViewController+Loader.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

protocol Loadable: AnyObject {
    func startLoader()
    func stopLoader()
}

extension Loadable where Self: UIViewController {
    func startLoader() {
        DispatchQueue.main.async {
            self.view.startLoader()
        }
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            self.view.stopLoader()
        }
    }
}
